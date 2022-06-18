require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ユーザー登録' do
    before do
      visit new_user_path
    end

    context 'ユーザー登録で正しい値が入力された場合' do
      it 'ユーザー登録が成功' do
        fill_in 'ネーム', with: 'test'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        attach_file('user_images', %w[spec/fixtures/images/runteq_man_top.png spec/fixtures/images/runteq_man.png])
        click_button '登録'
        expect(User.count).to eq 1
        expect(page).to have_content('ユーザー登録に成功しました')
        expect(page).to have_current_path(root_path)
      end
    end

    context 'ユーザー登録で誤った値が入力された場合' do
      it 'ネームを未記入' do
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(User.count).to eq 0
        expect(page).to have_content('ユーザー登録に失敗しました')
      end
    end
  end

  describe 'ユーザー編集' do
    let(:user) { create(:user) }

    before do
      login(user)
      visit edit_user_path(user)
    end

    context 'ユーザー編集で正しい値が入力された場合' do
      it 'ユーザー編集が成功' do
        fill_in 'ネーム', with: 'test1'
        fill_in 'メールアドレス', with: 'test1@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        attach_file('user_images', %w[spec/fixtures/images/runteq_man_top.png spec/fixtures/images/runteq_man.png])
        click_button '登録'
        expect(page).to have_content('登録情報を更新しました')
        expect(page).to have_current_path(root_path)
      end
    end

    context 'ユーザー編集で誤った値が入力された場合' do
      it 'ネームを未記入' do
        fill_in 'ネーム', with: ''
        fill_in 'メールアドレス', with: 'test1@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(page).to have_content('登録情報の更新に失敗しました')
        expect(page).to have_content('ネームを入力してください')
      end
    end

    context 'アップロード済の画像を削除' do
      it '画像が削除されること' do
        fill_in 'ネーム', with: 'test1'
        fill_in 'メールアドレス', with: 'test1@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        attach_file('user_images', %w[spec/fixtures/images/runteq_man_top.png spec/fixtures/images/runteq_man.png])
        click_button '登録'
        visit edit_user_path(user)
        expect(page).to have_selector('img[src$="runteq_man_top.png"]')
        click_on '削除', match: :first
        expect(page).not_to have_selector('img[src$="runteq_man_top.png"]')
      end
    end

    context '画像を1枚選択してアップロード' do
      it '画像がアップロードされること' do
        attach_file('user_images', 'spec/fixtures/images/runteq_man.png')
        click_on '登録'
        visit edit_user_path(user)
        expect(page).to have_selector('img[src$="runteq_man.png"]')
      end
    end

    context '画像を複数選択しアップロードした場合' do
      it '画像が複数登録' do
        attach_file('user_images', %w[spec/fixtures/images/runteq_man_top.png spec/fixtures/images/runteq_man.png])
        click_button '登録'
        visit edit_user_path(user)
        expect(page).to have_selector('img[src$="runteq_man.png"]')
        expect(page).to have_selector('img[src$="runteq_man_top.png"]')
      end
    end
  end
end
