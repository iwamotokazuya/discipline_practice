require 'rails_helper'

RSpec.describe 'Results', type: :system do
  let(:result) { create :result, score: 70 }
  let(:comment) { create :comment, comment: '良いですね。この調子でいきましょう！' }

  describe '結果表示' do
    before do
      visit result_path(result)
    end

    context '正常に録音が完了した場合' do
      it '総合スコア、フィードバックが表示されること' do
        expect(page).to have_content(result.score)
        expect(page).to have_content(comment.comment)
      end
    end

    context '録音に失敗した場合' do
      it 'オーディオが表示されないこと' do
        visit result_path(result)
        expect(page).not_to have_css '.audio'
        expect(page).to have_content('申し訳ございません。録音に失敗しました。')
        find('.btn-dark').click
        expect(page).to have_current_path('/records/new')
      end
    end
  end

  context 'ホームへ戻るを押した場合' do
    it 'ホームに戻る' do
      visit result_path(result)
      find('.btn-warning').click
      expect(page).to have_current_path(root_path)
    end
  end

  describe 'ログインユーザーの結果表示' do
    let(:user) { create(:user) }

    before do
      login(user)
      visit result_path(result)
    end

    context '正常に録音が完了した場合' do
      it 'ログインユーザーのnameが表示されること' do
        expect(page).to have_content(result.user.name)
      end
    end

    context 'もう一度挑戦するを押した場合' do
      it '録音画面にリダイレクトする' do
        expect(page).to have_css '.btn-secondary'
        find('.btn-secondary').click
        expect(page).to have_current_path('/records/new')
      end
    end

    context 'NEXT STEPを押した場合' do
      it '録音画面にリダイレクトする' do
        expect(page).to have_css '.btn-success'
        find('.btn-success').click
        expect(page).to have_current_path('/records/login_new')
      end
    end
  end
end
