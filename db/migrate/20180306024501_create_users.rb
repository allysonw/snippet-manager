class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.text :username
      t.text :email
      t.text :password_digest
      t.timestamps null: false
    end
  end
end
