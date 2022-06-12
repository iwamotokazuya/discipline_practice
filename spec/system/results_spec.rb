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
      it 'ユーザー登録ボタンが表示されないこと' do
        expect(page).not_to have_css '.audio'
        find('.btn-dark').click
        expect(page).to have_current_path('/records/new')
      end
    end
  end

  describe '結果をshareしよう！を押した場合' do
    it 'ツイッターシェアができる' do
      visit result_path(result)
      find('.btn-info').click
      switch_to_window(windows.last)
      expect(current_host).to eq('https://twitter.com/share?url=#{request.url}&text=しつけ度『#{@result.score}点』だったよ！%0a%0aあなたもペットに理想的なしつけを身につけませんか？')
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
