class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :category
      t.string :sub_category
      t.string :notes
      t.integer :amount_cents
      t.string :type

      t.timestamps null: false
    end
  end
end
