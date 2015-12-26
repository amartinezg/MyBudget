class MonetizeAccount < ActiveRecord::Migration
  def change
    add_monetize  :accounts, :balance, amount: { null: false, default: 0, postfix: '_cents' }
  end
end
