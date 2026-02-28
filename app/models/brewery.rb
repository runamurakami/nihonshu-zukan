class Brewery < ApplicationRecord
  belongs_to :prefecture, optional: true
  has_many :sakes, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :prefecture_id }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[prefecture]
  end
end
