# frozen_string_literal: true

class LessonsController < ApplicationController
  add_breadcrumb 'Musems', :courses_path

  before_action :authenticate_user!
  before_action :find_lesson, only: %i[show photos]
  before_action :payment_verification, only: %i[show photos]
  before_action :course_visible_verification, only: %i[show photos]

  def show
    # @photos = @lesson.photos.order(id: :asc).page(params[:page])

    @topics = @lesson.topic.course.topics.order(number: :asc)
    @lesson_topic_lessons = @lesson.topic.lessons.order(number: :asc)

    add_breadcrumb @lesson.topic.course.title, course_path(@lesson.topic.course)
    add_breadcrumb @lesson.topic.title, topic_path(@lesson.topic)
    add_breadcrumb @lesson.title, lesson_path(@lesson)
  end

  def photos
    @pagy, @lesson_photos = pagy(@lesson.photos.preload(url_attachment: :blob), items: 10)

    add_breadcrumb @lesson.topic.course.title, course_path(@lesson.topic.course)
    add_breadcrumb @lesson.topic.title, topic_path(@lesson.topic)
    add_breadcrumb @lesson.title, lesson_path(@lesson)
    add_breadcrumb "Photos", photos_lesson_path(@lesson)
  end

  private

  def find_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :body, :number, :video, :shape, :coords, test_attributes: %i[id], photos_attributes: %i[title description url])
  end

  def payment_verification
    unless current_user.course_purchased?(@lesson.topic.course) && current_user.topic_open?(@lesson.topic)
      redirect_to course_path(@lesson.topic.course), alert: 'Lesson locked!'
    end    
  end

  def course_visible_verification
    redirect_to root_path unless @lesson.topic.course.visible? || user_signed_in? && current_user.admin?
  end
end
