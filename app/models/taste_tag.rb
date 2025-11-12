class TasteTag < ApplicationRecord
    has_many :sake_taste_tags, dependent: :destroy
    has_many :sakes, through: :sake_taste_tags

    validates :name, presence: true, uniqueness: true
end
