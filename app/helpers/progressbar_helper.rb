# frozen_string_literal: true

module ProgressbarHelper
  # def helper_progress_prcnt(course)
  #   return 0 if course.tests_count == 0 || !user_signed_in?
  #   current_user.completeded_tests_from_course(course) == 0 ? 
  #     progress_prcnt = 0 : 
  #     progress_prcnt = current_user.completeded_tests_from_course(course) * 100 / (course.tests_count)
  # end

  def hlpr_progress_style
    if current_user.test_passages.completeded.include?(current_user)
      "#0DBFB3";
    # elsif progress_prcnt == 0
    #   'none';
    # else
    #   '#5BC0DE';
    end
  end
end
