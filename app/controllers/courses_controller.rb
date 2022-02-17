class CoursesController < ApplicationController
  add_breadcrumb 'Musems', :courses_path

  before_action :authenticate_user!, only: :own
  before_action :find_courses, only: :index
  before_action :find_course, only: %i[show own plan]
  before_action :course_visible_verification, only: %i[show own plan]

  def index
    # Course.update_all(updated_at: Time.now)

    @courses_palace_count = @courses.palace_category.load.size
    @courses_military_count = @courses.military_category.load.size
    @courses_other_count = @courses.other_category.load.size
    
    @hash = Gmaps4rails.build_markers(@courses) do |course, marker|
      marker.lat course.latitude
      marker.lng course.longitude
      marker.json({ title: course.title })
    end
  end

  def show
    add_breadcrumb @course.title, course_path(@course)

    @topics = @course.topics.order(number: :asc)
  end

  def plan; end

  def own
    #if @course.user_owns?(current_user) # || @course.price == 0
      @course.users.push(current_user) #if @course.price == 0

      redirect_to @course, notice: 'Course purchased!'
    #else
      # redirect_to root_path, notice: 'Course not own!'
    #end
  end

  private

  def find_courses
    @pagy, @courses = pagy(Course.with_attached_image.order(id: :desc))
  end
  
  def find_course
    @course = Course.with_attached_image.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:category, :title, :body, :video, :latitude, :longitude, :price, :image, :visible, test_attributes: %i[id])
  end

  def course_visible_verification
    redirect_to root_path unless @course.visible? || user_signed_in? && current_user.admin?
  end
end
