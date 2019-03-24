class ChangeDefaultStatusAtUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :status, :boolean
    add_column :users, :status, :boolean, default: true
  end
end
