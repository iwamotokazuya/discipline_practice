class Diary < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :start_time, presence: true
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :score, numericality: { only_integer: true }, presence: true
end
