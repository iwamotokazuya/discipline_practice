class CreateRanks < ActiveRecord::Migration[6.1]
  def change
    create_table :ranks do |t|
      t.string :level, null: false
      t.string :subtitle, null: false

      t.timestamps
    end
  end
end
