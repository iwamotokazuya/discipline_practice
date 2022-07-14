require 'rails_helper'

RSpec.describe Rank, type: :model do
  let(:rank) { create :rank }

  describe 'バリデーション' do
    it '値があればバリデーションが通ること' do
      expect(rank).to be_valid
    end

    it 'levelの値がなければバリデーションが通らないこと' do
      rank = build(:rank, level: nil)
      expect(rank.valid?).to be false
      expect(rank.errors[:level]).to include("を入力してください")
    end
  end
end
