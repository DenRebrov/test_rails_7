# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :lesson

  has_one_attached :url

  validates :title, :description, presence: true
end