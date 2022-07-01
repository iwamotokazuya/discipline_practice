class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :results, dependent: :destroy
  has_many :diaries, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_results, through: :likes, source: :result

  has_many_attached :images

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true, presence: true
  validates :name, length: { maximum: 10 }, presence: true

  validate :image_length

  def like(result)
    like_results << result
  end

  def unlike(result)
    like_results.destroy(result)
  end

  def like?(result)
    like_results.include?(result)
  end

  private

  def image_length
    errors.add(:images, 'は3枚以内にしてください') if images.length >= 4
  end
end
