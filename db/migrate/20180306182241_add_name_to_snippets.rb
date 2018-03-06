class AddNameToSnippets < ActiveRecord::Migration[5.1]
  def change
    add_column :snippets, :name, :text
  end
end
