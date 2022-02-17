# frozen_string_literal: true

class Test < ApplicationRecord
  belongs_to :testable, polymorphic: true
  
  has_many :questions, dependent: :destroy
  has_many :test_passages, dependent: :destroy
  has_many :users, through: :test_passages

  def correct_answers_count
    sum = 0
    questions.each { |question| sum += 1 if question.answers.correct }
    sum
  end

  def questions_and_answers?
    return false unless questions.present?

    result = 0
    questions.preload(:answers).each { |question| result += 1 if question.answers.present? }
    result == questions.size
  end

  def max_result
    max_result = self.test_passages.max_by(&:percentage_of_correct_answers)
    max_result.nil? ? 0 : max_result.percentage_of_correct_answers
  end
end