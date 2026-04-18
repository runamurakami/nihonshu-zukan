class CreateUserBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :user_badges do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :badge, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_badges, [ :user_id, :badge_id ], unique: true
    add_index :user_badges, :user_id
  end
end
