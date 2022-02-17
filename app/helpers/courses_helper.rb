module CoursesHelper
  PLUG = 'plug.jpg'.freeze
  
  def hlpr_course_img(course)
    return asset_path(PLUG) if course.is_a?(NilClass) || !course.image.attached?

    course.image
  end

  def hlpr_label_category_count(category_count)
    category_count > 6 ? "#{category_count}+" : category_count
  end

  def hlpr_course_status(progress)
    course_status = []

    case progress
    when nil
      course_status << 'danger'
      course_status << 'Purchase'
    when 100
      course_status << 'success'
      course_status << 'Completed'
    else
      course_status << 'info'
      course_status << 'In progress'
    end

    course_status
  end

  def hlpr_progress_value_changer(course)
    current_user.course_completed?(course) ? '#A4527C' : '#7CA452'
  end

  def hlpr_visible?(course)
    course.visible ? 'course-visible' : 'course-invisible'
  end
end
