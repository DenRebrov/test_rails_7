# frozen_string_literal: true

module TopicsHelper
  PLUG = 'plug.jpg'.freeze

  def hlpr_topic_img(topic)
    if topic.image && topic.image.attached?
      topic.image
    else
      asset_path(PLUG)
    end
  end

  def hlpr_topic_status(topic)
    topic_status = []

    if current_user.test_completed_for?(topic)
      topic_status << 'success'
      topic_status << 'Completed'
    elsif current_user.topic_open?(topic)
      topic_status << 'info'
      topic_status << 'In progress'
    else
      topic_status << 'danger'
      topic_status << 'Locked'
    end

    topic_status
  end

  def hlpr_topic_color_changer(topic_id, current_topic)
    topic_id == current_topic ? 'course-show-topic-plan-button-ok' : 'course-show-topic-plan-button'
  end

  # def helper_topic_img_title_changer(course, points)
  # 	clss = nil

  #   if course.user_owns?(current_user) && current_user.completeded_tests_from_course(course) >= points
  #     clss = "topic-img-size"
  #   else
  #     clss = "topic-img-size-locked"
  #   end

  #   clss
  # end

  # def helper_topic_text_title_changer(course, points)
  # 	clss = nil

  #   if course.user_owns?(current_user) && current_user.completeded_tests_from_course(course) >= points
  #     clss = "topic-title"
  #   else
  #     clss = "topic-title-locked"
  #   end

  #   clss
  # end
end

