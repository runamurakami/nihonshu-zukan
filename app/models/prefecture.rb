class Prefecture < ApplicationRecord
  has_many :breweries, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    %w[breweries]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
