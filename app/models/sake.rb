class Sake < ApplicationRecord
  belongs_to :user

  belongs_to :brewery
  has_one :prefecture, through: :brewery

  has_many :sake_taste_tags, dependent: :destroy
  has_many :taste_tags, through: :sake_taste_tags

  has_one_attached :label_image
end
