class ChangeDefaultStatusAtUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :status, :integer, default: 1
  end
end
