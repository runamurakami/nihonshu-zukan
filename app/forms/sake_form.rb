class SakeForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  
  attr_accessor :name, :brewery_name, :prefecture_id, :sake_meter_value, :rating, :taste_tags, :label_image, :comment, :user
  
  validates :name, :brewery_name, presence: true
  
  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      brewery = Brewery.find_or_create_by!(name: brewery_name, prefecture_id: prefecture_id)
      sake = Sake.new(
        name: name,
        brewery: brewery,
        sake_meter_value: sake_meter_value,
        rating: rating,
        comment: comment,
        user: user
      )
      sake.label_image.attach(label_image) if label_image.present?
      sake.save!

      tag_names = taste_tags.to_s.split(/[,\u3001]/).map(&:strip).reject(&:blank?)
      tag_names.each do |tag_name|
        tag = TasteTag.find_or_create_by!(name: tag_name)
        SakeTasteTag.create!(sake: sake, taste_tag: tag)
      end
    end
    true
    rescue ActiveRecord::RecordInvalid
    false
  end
end
