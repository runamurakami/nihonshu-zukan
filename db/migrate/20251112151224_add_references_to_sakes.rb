class AddReferencesToSakes < ActiveRecord::Migration[7.2]
  def change
    add_reference :sakes, :brewery, null: false, foreign_key: true
  end
end
