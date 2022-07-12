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
        expect(page).to have_current_path(new_record_path(part: 'all'))
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
        expect(page).to have_current_path(ranks_path)
      end
    end

    context 'NEXT STEPを押した場合' do
      it '録音画面にリダイレクトする' do
        expect(page).to have_css '.btn-success'
        find('.btn-success').click
        expect(page).to have_current_path(ranks_path(next: 'step'))
      end
    end

    context 'お気に入りボタンをクリック' do
      it 'お気に入りになる' do
        find('.like').click
        expect(page).to have_css '.unlike'
        expect(page).to have_content('お気に入りに登録しました。')
        expect(page).to have_current_path(result_path(result))
      end
    end
  end

  describe 'お気に入りの画面' do
    let(:user) { create(:user) }
    let!(:like) { create(:like, result: result, user: user) }

    before do
      login(user)
      visit likes_results_path
    end

    context 'お気に入り一覧' do
      it 'お気に入りが表示される' do
        like_list = result.score
        expect(page).to have_content like_list[0]
        expect(current_path).to eq likes_results_path
      end
    end
  end
end
