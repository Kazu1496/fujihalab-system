class UpdateOptionsForDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :total, :integer, default: 0
    change_column :users, :status, :boolean, default: false
    change_column :existences, :stay_time, :integer, default: 0
  end
end
