class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|

      t.integer :user_id, null: false
      t.string  :title, null: false
      t.integer :genre_id, null: false
      t.datetime :start_time
      t.string :media
      t.float :rate
      t.text :impression
      t.boolean :is_watched, default: false
      t.timestamps
    end
  end
end
