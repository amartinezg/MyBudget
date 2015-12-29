class AddUniquenessToAccounts < ActiveRecord::Migration
  def change
    add_index "accounts", ["name", "type", "balance_currency"], :unique => true
  end
end
