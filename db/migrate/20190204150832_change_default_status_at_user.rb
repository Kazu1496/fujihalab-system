class ChangeDefaultStatusAtUser < ActiveRecord::Migration[5.2]
  def change
    if ENV['RAILS_ENV'] == 'production'
      change_column :users, :status, 'integer USING CAST(status AS integer)', default: 1
    end
  end
end
