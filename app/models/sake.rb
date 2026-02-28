class Sake < ApplicationRecord
  belongs_to :user

  belongs_to :brewery
  has_one :prefecture, through: :brewery, source: :prefecture

  has_many :sake_taste_tags, dependent: :destroy
  has_many :taste_tags, through: :sake_taste_tags

  has_one_attached :label_image

  def self.ransackable_attributes(auth_object = nil)
    %w[name rating sake_meter_value]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[brewery taste_tags]
  end
end
