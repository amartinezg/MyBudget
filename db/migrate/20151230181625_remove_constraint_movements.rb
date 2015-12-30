class RemoveConstraintMovements < ActiveRecord::Migration
  def change
    change_column_null :movements, :account_id, true
  end
end
