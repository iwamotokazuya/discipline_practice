require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    it '各カラムに適正な値があればバリデーションが通ること' do
      comment = build(:comment)
      expect(comment).to be_valid
    end
  end
end
