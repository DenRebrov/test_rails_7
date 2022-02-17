# frozen_string_literal: true

module LessonsHelper
  PLUG = 'plug.jpg'.freeze
  
  def hlpr_lesson_img(lesson)
    if lesson.photos.first && lesson.photos.first.url.attached?
      lesson.photos.first.url
    else
      asset_path(PLUG)
    end
  end

  def hlpr_lesson_color_changer(lesson_id, current_lesson)
    lesson_id == current_lesson ? 'lesson-plan-button-ok' : 'lesson-plan-button'
  end
end
