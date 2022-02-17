# frozen_string_literal: true

module AnswersHelper

  def hlpr_correct_answer_changer(answer)
    clss = answer.correct ? clss = "label label-success" : clss = "label label-default"
  end
end
