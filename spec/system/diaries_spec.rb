require 'rails_helper'

RSpec.describe 'Diaries', type: :system do
  let(:user) { create(:user) }
  before do
    login(user)
  end

  describe 'しつけ成長期記入' do
    before do
      visit new_diary_path
    end

    context 'しつけ登録で正しい値が入力された場合' do
      it 'しつけ登録が成功' do
        fill_in 'しつけた内容', with: 'test'
        fill_in 'しつけた日付', with: '002022-6-15'
        fill_in 'しつけ自己採点', with: 100
        fill_in '詳細', with: 'testです'
        click_button '登録'
        expect(Diary.count).to eq 1
        expect(page).to have_current_path(diaries_path)
        expect(page).to have_content('日記の登録に成功しました')
      end
    end

    context 'しつけ登録で誤った値が入力された場合' do
      it 'しつけた内容を未記入' do
        fill_in 'しつけた内容', with: ''
        fill_in 'しつけた日付', with: '002022-6-15'
        fill_in 'しつけ自己採点', with: 100
        fill_in '詳細', with: 'testです'
        click_button '登録'
        expect(Diary.count).to eq 0
        expect(page).to have_content('日記の登録に失敗しました')
      end
    end
  end

  describe '一覧画面' do
    let(:diary) { create(:diary) }

    before do
      visit diaries_path
    end

    context '一覧ページにアクセス' do
      it '記入した記録が表示される' do
        task_list = create_list(:diary, 3)
        visit diaries_path
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[2].title
        expect(current_path).to eq diaries_path
      end
    end

    context 'カレンダー' do
      it '矢印クリックで月が変わる' do
        expect(page).to have_content('6月 2022')
        click_on '>>'
        expect(page).to have_content('7月 2022')
      end
    end
  end

  describe 'しつけ詳細' do
    let(:diary) { create(:diary) }

    before do
      visit diary_path(diary)
    end

    context '詳細ページにアクセス' do
      it '詳細が表示される' do
        expect(page).to have_content diary.title
        expect(current_path).to eq diary_path(diary)
      end

      it '編集ボタンをクリックすると編集画面へ遷移する' do
        expect(page).to have_css '.btn-dark'
        find('.btn-dark').click
        expect(current_path).to eq edit_diary_path(diary)
      end

      it '戻るボタンをクリックすると一覧へ遷移する' do
        expect(page).to have_css '.btn-light'
        find('.btn-light').click
        expect(current_path).to eq diaries_path
      end

      it '削除ボタンをクリックするとしつけが削除される' do
        expect(page).to have_css '.btn-danger'
        find('.btn-danger').click
        expect(page.accept_confirm).to eq '削除してもよろしいですか？'
        expect(page).to have_content '日記を削除しました'
        expect(current_path).to eq diaries_path
        expect(page).not_to have_content diary.title
      end
    end
  end

  describe 'しつけ編集' do
    let(:diary) { create(:diary) }

    before do
      visit edit_diary_path(diary)
    end

    context 'しつけ編集で正しい値が入力された場合' do
      it 'しつけ編集が成功' do
        fill_in 'しつけた内容', with: 'test1'
        fill_in 'しつけた日付', with: '002022-6-12'
        fill_in 'しつけ自己採点', with: 1
        fill_in '詳細', with: 'MyText'
        click_button '登録'
        expect(page).to have_current_path(diaries_path)
        expect(page).to have_content('編集しました')
      end
    end

    context 'しつけ編集で誤った値が入力された場合' do
      it 'しつけた内容を未記入' do
        fill_in 'しつけた内容', with: ''
        fill_in 'しつけた日付', with: '002022-6-12'
        fill_in 'しつけ自己採点', with: 1
        fill_in '詳細', with: 'MyText'
        click_button '登録'
        expect(page).to have_content('しつけた内容を入力してください')
      end
    end
  end
end
