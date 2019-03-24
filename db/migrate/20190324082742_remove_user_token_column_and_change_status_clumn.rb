class RemoveUserTokenColumnAndChangeStatusClumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :pixela_token, :string
  end
end
