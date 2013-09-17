class RenameColumnInMyQueues < ActiveRecord::Migration
  def change
    rename_column :my_queues, :order, :order_id
  end
end
