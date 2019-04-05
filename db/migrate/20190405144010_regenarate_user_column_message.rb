class RegenarateUserColumnMessage < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :message, :string
    add_column :users, :message, :string
  end
end
