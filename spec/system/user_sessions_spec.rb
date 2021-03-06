require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'ログインで正しい値が入力された場合' do
      it 'ログインが成功' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログインに成功しました'
        expect(page).to have_current_path root_path
      end
    end

    context 'ユーザー登録で誤った値が入力された場合' do
      it 'メールアドレスが未記入' do
        visit login_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログインに失敗しました'
        expect(page).to have_current_path login_path
      end
    end
  end

  describe 'ログイン後' do
    it 'ログアウトボタンをクリックしてログアウトが成功すること' do
      login(user)
      click_link 'ログアウト'
      expect(page).to have_content 'ログアウトしました'
      expect(page).to have_current_path root_path
    end
  end
end
