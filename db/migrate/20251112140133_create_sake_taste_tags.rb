class CreateSakeTasteTags < ActiveRecord::Migration[7.2]
  def change
    create_table :sake_taste_tags do |t|
      t.references :sake, null: false, foreign_key: true
      t.references :taste_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
