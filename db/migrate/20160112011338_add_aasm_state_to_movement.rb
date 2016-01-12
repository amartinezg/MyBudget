class AddAasmStateToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :aasm_state, :string
  end
end
