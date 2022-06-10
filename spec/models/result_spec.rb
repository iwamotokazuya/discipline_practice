require 'rails_helper'

RSpec.describe Result, type: :model do
  let(:result) { create :result }

  describe 'バリデーション' do
    it '値があればバリデーションが通ること' do
      expect(result).to be_valid
    end

    it 'score' do
      result = build(:result, score: nil)
      expect(result.valid?).to be false
    end

    it 'calm' do
      result = build(:result, calm: nil)
      expect(result.valid?).to be false
    end

    it 'anger' do
      result = build(:result, anger: nil)
      expect(result.valid?).to be false
    end

    it 'joy' do
      result = build(:result, joy: nil)
      expect(result.valid?).to be false
    end

    it 'sorrow' do
      result = build(:result, sorrow: nil)
      expect(result.valid?).to be false
    end

    it 'energy' do
      result = build(:result, energy: nil)
      expect(result.valid?).to be false
    end
  end
end
