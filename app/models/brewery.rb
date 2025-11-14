class Brewery < ApplicationRecord
  belongs_to :prefecture, optional: true
  has_many :sakes, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :prefecture_id }
end
