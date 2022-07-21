class RenameStartTimeColumnToResults < ActiveRecord::Migration[6.1]
  def change
    rename_column :results, :start_time, :start_date
  end
end
