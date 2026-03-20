class AddStatusToSakes < ActiveRecord::Migration[7.2]
  def change
    add_column :sakes, :status, :integer, default: 0, null: false
  end
end
