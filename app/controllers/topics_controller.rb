# frozen_string_literal: true

class TopicsController < ApplicationController
  add_breadcrumb 'Musems', :courses_path

  before_action :authenticate_user!
  before_action :find_topic, only: %i[show plan]
  before_action :payment_verification, only: %i[show plan]
  before_action :course_visible_verification, only: %i[show plan]

  def show
    @topics = @topic.course.topics.order(number: :asc)
    @topic_lessons = @topic.lessons.order(number: :asc)

    add_breadcrumb @topic.course.title, course_path(@topic.course)
    add_breadcrumb @topic.title, topic_path(@topic)
  end

  # def plan
  #   @topics = @topic.course.topics.order(number: :asc)
  #   @topic_lessons = @topic.lessons.order(number: :asc)
  # end

  private
  
  def find_topic
    @topic = Topic.with_attached_image.preload(:test).find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :body, :number, :video, :shape, :coords, :image, test_attributes: %i[id])
  end

  def payment_verification
    unless current_user.course_purchased?(@topic.course) && current_user.topic_open?(@topic)
      redirect_to course_path(@topic.course), alert: 'You did not purchase this course'
    end 
  end

  def course_visible_verification
    redirect_to root_path unless @topic.course.visible? || user_signed_in? && current_user.admin?
  end
end
