class AddUserIdToLabels < ActiveRecord::Migration[5.1]
  def change
    add_column :labels, :user_id, :integer
  end
end
