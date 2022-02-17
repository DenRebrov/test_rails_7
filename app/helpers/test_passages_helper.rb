# frozen_string_literal: true

module TestPassagesHelper

  def hlpr_help_title_color_changer(condition)
    condition ? 'lightgrey;' : '#527CA4;'
  end

  def helper_test_passage_progress(test_passage)
    return 0 if test_passage.total_questions == 0
    progress_prcnt = test_passage.question_number * 100 / test_passage.total_questions
    progress_prcnt
  end

  def helper_fill_color_changer(percent)
  	color = nil

    if percent >= 100
      color = "#9bffff"
    elsif percent >= 80
      color = "mediumspringgreen"
    elsif percent >= 60
      color = "lightyellow"
    elsif percent >= 40
      color = "#FFA76C"
    elsif percent >= 20
      color = "lightcoral"
    else
      color = "violet"
    end

    color
  end

  def helper_stroke_color_changer(percent)
  	color = nil

    if percent >= 100
      color = "dodgerblue"
    elsif percent >= 80
      color = "limegreen"
    elsif percent >= 60
      color = "gold"
    elsif percent >= 40
      color = "darkorange"
    elsif percent >= 20
      color = "crimson"
    else
      color = "magenta"
    end

    color
  end
end
