# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :course_users, dependent: :destroy
  has_many :users, through: :course_users

  has_many :topics, dependent: :destroy
  has_one :test, dependent: :destroy, as: :testable
  
  has_one_attached :image

  accepts_nested_attributes_for :test, reject_if: :all_blank

  validates :title, presence: true, length: { maximum: 40 }
  validates :body, presence: true

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  scope :palace_category, -> { where('courses.category = ?', 'palace') }
  scope :military_category, -> { where('courses.category = ?', 'military') }
  scope :other_category, -> { where('courses.category = ?', 'other') }

  def first_topic
    topics.min_by(&:number)
  end

  def last_topic
    topics.max_by(&:number)
  end

  def tests_count
    course_tests_count = 1

    topics.preload(:lessons).each do |topic|
      course_tests_count += topic.tests_count
    end

    course_tests_count
  end

  def country
    address.split(',').pop if address
  end

  def city
    address.split(',')[3] if address
  end
end