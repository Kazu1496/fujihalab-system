class RemoveExistenceStayTimeColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :existences, :stay_time, :integer
  end
end
