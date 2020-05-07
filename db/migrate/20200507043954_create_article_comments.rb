class CreateArticleComments < ActiveRecord::Migration[5.2]
  def change
    create_table :article_comments do |t|
      t.integer :user_id
      t.integer :article_id
      t.text :content
      t.timestamps
    end
  end
end
