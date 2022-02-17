# frozen_string_literal: true

class Topic < ApplicationRecord
  belongs_to :course
  has_one :test, dependent: :destroy, as: :testable
  has_many :lessons, dependent: :destroy
  has_one_attached :image
  
  accepts_nested_attributes_for :test, reject_if: :all_blank

  validates :title, presence: true, length: { maximum: 60 }
  validates :body, presence: true
  validates :number, presence: true

  def first_lesson
    first_lesson = lessons.min_by(&:number)
  end

  def last_lesson
    last_lesson = lessons.max_by(&:number)
  end

  def next_topic
    self.course.topics.order(:number).where('number > ?', self.number).first
  end

  def previous_topic
    self.course.topics.order(number: :desc).where('number < ?', self.number).first
  end

  def tests_count
    count = 1

    lessons.each { |lesson| count += 1 }

    count
  end
end