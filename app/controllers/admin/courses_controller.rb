# frozen_string_literal: true

class Admin::CoursesController < Admin::BaseController
  before_action :authenticate_user!
  before_action :find_course, only: %i[show edit update destroy]

  add_breadcrumb 'Admin panel', :admin_courses_path

  def show
    add_breadcrumb @course.title, admin_course_path(@course)

    # @pagy, @course_topics = pagy(@course.topics.order("number ASC"), items: 10)
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.test = @course.build_test

    if @course.save
      current_user.add_progress_to_course(@course)
      redirect_to admin_course_path(@course), notice: 'Course created!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @course.update(course_params)
      redirect_to admin_course_path(@course), notice: 'Course updated!'
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    current_user.add_progress_to_course(@course)
    redirect_to admin_welcome_index_path, notice: 'Your course succesfully deleted.'
  end

  private

  def find_course
    @course = Course.with_attached_image.find(params[:id])
    # @course = Course.preload(:images_attachments).find(params[:id])
  end

  def course_params
    params.require(:course).permit(:category, :title, :body, :video, :latitude, :longitude, :price, :image, :visible, test_attributes: %i[id])
  end
end