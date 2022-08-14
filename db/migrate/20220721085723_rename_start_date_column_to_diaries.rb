class RenameStartDateColumnToDiaries < ActiveRecord::Migration[6.1]
  def change
    rename_column :diaries, :start_date, :start_time
  end
end
