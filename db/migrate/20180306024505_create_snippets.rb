class CreateSnippets < ActiveRecord::Migration[5.1]
  def change
    create_table :snippets do |t|
      t.text :language
      t.text :content
      t.text :access_level
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
