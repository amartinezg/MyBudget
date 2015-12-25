class AddAccountIdToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :account_id, :string, null: false
  end
end
