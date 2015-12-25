class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :type
      t.integer :balance_cents
      t.string :type
      t.string :currency

      t.timestamps null: false
    end
  end
end
