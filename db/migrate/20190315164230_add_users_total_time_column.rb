class AddUsersTotalTimeColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :total_time, :integer, default: 0
  end
end
