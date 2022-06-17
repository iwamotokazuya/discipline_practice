class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :results, dependent: :destroy
  has_many :diaries, dependent: :destroy

  has_many_attached :images

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true, presence: true
  validates :name, length: { maximum: 10 }, presence: true

  validate :image_length

  private

  def image_length
    errors.add(:images, 'は3枚以内にしてください') if images.length >= 4
  end
end
