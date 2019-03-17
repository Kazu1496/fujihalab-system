class ChangeDefaultStatusAtUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :status, :boolean
    add_column :users, :status, :integer, default: 1
  end
end
