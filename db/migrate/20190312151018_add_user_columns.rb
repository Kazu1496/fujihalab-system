class AddUserColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image, :string
    add_column :users, :pixela_token, :string
  end
end
