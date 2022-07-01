require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    subject { like.valid? }

    let!(:other_like) { create(:like) }
    let(:like) { build(:like) }

    context '1User 1Result 1いいね' do
      it 'あるUserが同じResultにいいね出来ないこと' do
        like.user = other_like.user
        like.result = other_like.result
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N+1となっている' do
        expect(Like.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Resultモデルとの関係' do
      it 'N+1となっている' do
        expect(Like.reflect_on_association(:result).macro).to eq :belongs_to
      end
    end
  end
end
