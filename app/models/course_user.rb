# frozen_string_literal: true

class CourseUser < ApplicationRecord
  belongs_to :course
  belongs_to :user

  def add_progress_to_course(user)
    # return unless courses.include?(course)
    prgrs = 0

    course.topics.preload(:test).each do |topic|
      topic.lessons.preload(:test).each do |lesson|
        prgrs += 1 if user.test_passed?(lesson.test)
      end
      prgrs += 1 if user.test_passed?(topic.test)
    end

    prgrs += 1 if user.test_passed?(course.test)

    if prgrs > 0
      prgrs *= 100
      prgrs /= course.tests_count
    end

    self.progress = prgrs
    save!
  end

end