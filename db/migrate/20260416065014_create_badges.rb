class CreateBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.string :condition_type, null: false
      t.integer :condition_value
      t.string :region
      t.string :icon_path
      t.integer :position

      t.timestamps
    end

    add_index :badges, :name, unique: true
    add_index :badges, :position
  end
end
