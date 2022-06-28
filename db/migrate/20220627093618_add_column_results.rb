class AddColumnResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :start_time, :date
  end
end
