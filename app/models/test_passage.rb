# frozen_string_literal: true

class TestPassage < ApplicationRecord
  SUCCESS_RATE = 80
  TIME_TO_ANSWER = 60

  belongs_to :user
  belongs_to :test
  belongs_to :current_question, class_name: 'Question', optional: true

  before_validation :before_validation_set_first_question, on: %i[create update]
  before_validation :before_validation_null_help_hash, on: %i[create update]

  scope :completeded, -> { where(passed: true) }

  def accept!(answer_ids)
    if correct_answer?(answer_ids)
      self.correct_questions += 1
    else
      self.current_question.help_hash[:error_protection] += 1
    end

    save!
  end

  def completed?
    current_question.nil?
  end

  def success?
    if test.correct_answers_count.zero?
      false
    else
      correct_questions * 100 / test.correct_answers_count >= SUCCESS_RATE
    end
  end

  # def add_test_pass
  #   self.number += 1
  #   save!
  # end

  # def calculate_success_points
  #   points = 0
  #   success_percent = correct_questions * 100 / test.correct_answers_count

  #   if success_percent > 99
  #     points = 5
  #   elsif success_percent >= 80 && success_percent < 100
  #     points = 4
  #   elsif success_percent >= 60 && success_percent < 80
  #     points = 3
  #   elsif success_percent >= 40 && success_percent < 60
  #     points = 2
  #   elsif success_percent >= 20 && success_percent < 40
  #     points = 1
  #   else
  #     points = 0
  #   end

  #   points
  # end

  def total_questions
    test.questions.size
  end

  def question_number
    test.questions.sort.index(current_question) + 1
  end

  def percentage_of_correct_answers
    correct_questions * 100 / test.correct_answers_count
  end

  def use_help(help_type)
    case help_type
    when :fifty_fifty
      unless help_fifty_fifty_used
        toggle!(:help_fifty_fifty_used)
        current_question.add_help_fifty_fifty
        return true
      end
    when :overtime
      unless help_overtime_used
        toggle!(:help_overtime_used)
        current_question.add_help_overtime
        return true
      end
    when :google_hint
      unless help_google_hint_used
        toggle!(:help_google_hint_used)
        current_question.add_help_google_hint
        return true
      end
    when :error_protection
      unless help_error_protection_used
        toggle!(:help_error_protection_used)
        current_question.add_help_error_protection
        return true
      end
    end

    false
  end

  def answers_or_semi_answers
    current_question.correct_answers_in_help_hash? ? current_question.help_hash[:fifty_fifty].shuffle : current_question.answers.shuffle
  end

  def time_over?
    Time.now.to_i - question_start_time >= TIME_TO_ANSWER
  end

  def question_start_time
    start = current_question.time_start
    start += TIME_TO_ANSWER * 2 if current_question.overtime_in_help_hash?
    start
  end

  private

  def before_validation_set_first_question
    self.current_question = !current_question.nil? && current_question.error_protection_activated_and_answer_is_wrong? ? current_question : next_question
  end

  def before_validation_null_help_hash
    current_question.null_help_hash if current_question
  end

  def next_question
    test.questions.order(:id).where('id > ?', current_question.nil? ? 0 : current_question.id).first
  end

  def correct_answer?(answer_ids)
    correct_answers.ids.sort == answer_ids.map(&:to_i).sort unless answer_ids.nil?
  end

  def correct_answers
    current_question.answers.correct
  end
end