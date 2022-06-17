require 'rails_helper'

RSpec.describe Diary, type: :model do
  let(:diary) { create :diary }

  describe 'バリデーション' do
    it 'タイトル・日付・得点・詳細があれば登録できること' do
      expect(diary).to be_valid
    end

    it 'タイトルの記入がなければ登録できないこと' do
      diary = build(:diary, title: nil)
      expect(diary.valid?).to be false
      expect(diary.errors[:title]).to include('を入力してください')
    end

    it '日付の記入がなければ登録できないこと' do
      diary = build(:diary, start_time: nil)
      expect(diary.valid?).to be false
      expect(diary.errors[:start_time]).to include('を入力してください')
    end

    it '得点の記入がなければ登録できないこと' do
      diary = build(:diary, score: nil)
      expect(diary.valid?).to be false
      expect(diary.errors[:score]).to include('を入力してください')
    end

    it '得点の記入が整数でなければ登録できないこと' do
      diary = build(:diary, score: 'aa')
      expect(diary.valid?).to be false
      expect(diary.errors[:score]).to include('は数値で入力してください')
    end

    it '詳細の記入がなければ登録できないこと' do
      diary = build(:diary, body: nil)
      expect(diary.valid?).to be false
      expect(diary.errors[:body]).to include('を入力してください')
    end
  end
end
