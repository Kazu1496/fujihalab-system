class CreateExistences < ActiveRecord::Migration[5.2]
  def change
    create_table :existences do |t|
      t.integer :name_id
      t.datetime :enter_time
      t.datetime :exit_time
      t.integer :stay_time

      t.timestamps
    end
  end
end
