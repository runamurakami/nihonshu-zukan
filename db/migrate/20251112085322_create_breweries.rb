class CreateBreweries < ActiveRecord::Migration[7.2]
  def change
    create_table :breweries do |t|
      t.string :name
      t.references :prefecture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
