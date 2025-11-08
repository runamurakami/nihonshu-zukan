class Sake < ApplicationRecord
  belongs_to :user
  has_one_attached :label_image
end
