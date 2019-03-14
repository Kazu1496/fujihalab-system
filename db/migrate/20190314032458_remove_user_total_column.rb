class RemoveUserTotalColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :total, :integer
  end
end
