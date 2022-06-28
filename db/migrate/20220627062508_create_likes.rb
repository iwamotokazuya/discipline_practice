class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.string :result_id, null: false

      t.timestamps
    end
    add_foreign_key :likes, :results
    add_index  :likes, :result_id
  end
end
