require 'rails_helper'

RSpec.describe 'Ranks', type: :system do
  let(:rank) { create(:rank) }

  describe 'レベル選択ページ' do

    before do
      visit ranks_path
    end

    it 'レベルを選択すると録音ページに遷移すること' do
      expect(page).to have_css '.beginner'
      expect(page).to have_css '.intermediate'
      expect(page).to have_css '.advanced'
      find('.beginner').click
      expect(page).to have_current_path(record_rank_path(id: 1, part: 'all', beginner: 'all'))
    end
  end
  end
end