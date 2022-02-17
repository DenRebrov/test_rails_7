# frozen_string_literal: true

module TestsHelper
  def hlpr_test_ready_checker(test)
  	if test.questions_and_answers?
  	  "green"
  	else
  	  "red"
  	end
  end

  def hlpr_test_completed?(test)
    result = current_user.test_completed_for?(test.testable) ? ['#7CA452', 'Completed!'] : ['#A4527C', 'Not finished...']
  end
end
