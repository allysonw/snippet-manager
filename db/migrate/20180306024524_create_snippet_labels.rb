class CreateSnippetLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :snippet_labels do |t|
      t.integer :snippet_id
      t.integer :label_id
    end
  end
end
