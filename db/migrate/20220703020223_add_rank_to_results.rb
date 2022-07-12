class AddRankToResults < ActiveRecord::Migration[6.1]
  def change
    add_reference :results, :rank, foreign_key: true
  end
end
