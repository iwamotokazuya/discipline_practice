require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe 'バリデーション' do
    it 'ネーム・メールアドレス・パスワードがあれば登録できること' do
      expect(user).to be_valid
    end

    it 'ネームがなければ登録できないこと' do
      user = build(:user, name: nil)
      expect(user.valid?).to be false
    end

    it 'ネームは10文字以内であること' do
      user = build(:user, name: "more_than_eleven")
      expect(user.valid?).to be false
    end

    it 'メールアドレスがなければ登録できないこと' do
      user = build(:user, email: nil)
      expect(user.valid?).to be false
    end

    it '同じメールアドレスでは登録できないこと' do
      duplicated_user = build(:user, email: user.email)
      expect(duplicated_user.valid?).to be false
    end

    it 'パスワードがなければ登録できないこと' do
      user = build(:user, password: nil)
      expect(user.valid?).to be false
    end

    it 'パスワードは3文字以上であること' do
      user = build(:user, password: "pw")
      expect(user.valid?).to be false
    end
 
    it 'パスワード確認がなければ登録できないこと' do
      user = build(:user, password_confirmation: nil)
      expect(user.valid?).to be false
    end
  end
end
