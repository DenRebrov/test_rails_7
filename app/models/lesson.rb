class Lesson < ApplicationRecord
  belongs_to :topic
  has_one :test, dependent: :destroy, as: :testable
  has_many :photos, dependent: :destroy

  accepts_nested_attributes_for :test, reject_if: :all_blank
  accepts_nested_attributes_for :photos, reject_if: :all_blank

  validates :topic, :title, :body, presence: true

  def next_lesson
    self.topic.lessons.order(:number).where('number > ?', self.number).first
  end

  def previous_lesson
  	self.topic.lessons.order(number: :desc).where('number < ?', self.number).first
  end

  def photo_number(number)
    desired_photo = nil
    photos_array = []

    if photos.preload(:url_attachment).load.size >= number
      photos_array = photos.first(number)
    else
      return desired_photo = photos.first
    end

    desired_photo = photos_array.last
  end
end

