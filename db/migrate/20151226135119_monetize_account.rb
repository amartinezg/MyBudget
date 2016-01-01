class MonetizeAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :balance_cents if column_exists?(:accounts, :balance_cents)
    add_monetize  :accounts, :balance, amount: { null: false, default: 0, postfix: '_cents' }
  end
end
