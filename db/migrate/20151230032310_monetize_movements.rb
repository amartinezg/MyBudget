class MonetizeMovements < ActiveRecord::Migration
  def change
    remove_column :movements, :amount_cents
    add_monetize :movements, :amount, amount: { null: false, default: 0, postfix: '_cents' }
  end
end
