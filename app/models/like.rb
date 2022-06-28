class Like < ApplicationRecord
  belongs_to :user
  belongs_to :result

  validates :user_id, uniqueness: { scope: :result_id }
end
