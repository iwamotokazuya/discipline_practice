class CreateDiaries < ActiveRecord::Migration[6.1]
  def change
    create_table :diaries do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.date :start_time, null: false
      t.integer :score, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
