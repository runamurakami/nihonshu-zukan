class CreateSakes < ActiveRecord::Migration[7.2]
  def change
    create_table :sakes do |t|
      t.string :name
      t.string :brewery_name
      t.string :prefecture_name
      t.string :sake_meter_value
      t.integer :rating
      t.string :taste_tag_name
      t.text :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
