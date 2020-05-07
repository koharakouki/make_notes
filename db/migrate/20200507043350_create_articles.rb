class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.string :article_title
      t.text :content
      t.boolean :is_spoiler, default: false
      t.timestamps
    end
  end
end
