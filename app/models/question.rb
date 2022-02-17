# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :test
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: :all_blank

  validates :body, presence: true

  serialize :help_hash, Hash

  def add_help_fifty_fifty
    self.help_hash[:fifty_fifty] = answers_after_fifty_fifty
    save
  end

  def add_help_overtime
    self.help_hash[:overtime] = true
    save
  end

  def add_help_google_hint
    self.help_hash[:google_hint] = self.hint
    save
  end

  def add_help_error_protection
    self.help_hash[:error_protection] += 1
    save
  end

  def null_help_hash
    self.help_hash[:fifty_fifty] = [''] unless error_protection_activated_and_answer_is_wrong?
    self.help_hash[:overtime] = false
    self.help_hash[:google_hint] = ['']
    self.help_hash[:error_protection] = 0
    save
  end

  def answers_after_fifty_fifty
    correct_answers = []
    wrong_answers = []

    answers.correct.each { |answer| correct_answers << answer }

    if answers.wrong.present?
      answers.wrong.each { |answer| wrong_answers << answer }
      wrong_answers.shuffle
      
      count = (answers.wrong.load.size / 2) + 1
      count.times { wrong_answers.pop }
    end

    correct_answers.concat wrong_answers
  end

  def correct_answers_in_help_hash?
    help_hash[:fifty_fifty] == answers_after_fifty_fifty
  end

  def overtime_in_help_hash?
    help_hash[:overtime] == true
  end

  def google_hint_in_help_hash?
    help_hash[:google_hint] == hint
  end

  def error_protection_activated_and_answer_is_wrong?
    help_hash[:error_protection] == 2
  end
end