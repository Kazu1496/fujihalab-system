class ExistenceChangeNameNameIdUserId < ActiveRecord::Migration[5.2]
  def change
    rename_column :existences, :name_id, :user_id
  end
end
