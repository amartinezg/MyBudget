class AddPeriodToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :period, :date
  end
end
