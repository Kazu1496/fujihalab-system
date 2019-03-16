class RemoveAddUserStatusColumn < ActiveRecord::Migration[5.2]
  def change
    if ENV['RAILS_ENV'] == 'production'
      remove_column :users, :status, :integer
      add_column :users, :status, 'integer USING CAST(status AS integer)', default: 1
    end
  end
end
