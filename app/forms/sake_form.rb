class SakeForm
    include ActiveModel::Model
    include ActiveModel::Attributes
  
    attr_accessor :name, :brewery_name, :prefecture_id, :sake_meter_value, :rating, :taste_tags, :label_image, :comment, :user
  
    validates :name, :brewery_name, presence: true
  
    def save
      return false unless valid?
  
      ActiveRecord::Base.transaction do
        Rails.logger.debug "=== SakeForm: start transaction ==="
        brewery = Brewery.find_or_create_by!(name: brewery_name, prefecture_id: prefecture_id)
        Rails.logger.debug "Brewery created/found: #{brewery.inspect}"
        sake = Sake.new(
          name: name,
          brewery: brewery,
          sake_meter_value: sake_meter_value,
          rating: rating,
          comment: comment,
          user: user
        )
        Rails.logger.debug "Sake initialized: #{sake.inspect}"
        sake.label_image.attach(label_image) if label_image.present?
        sake.save!
        Rails.logger.debug "Sake saved successfully: #{sake.id}"

  
        # taste_tagsがあれば処理
        Array(taste_tags).each do |tag_name|
          tag = TasteTag.find_or_create_by!(name: tag_name.strip)
          SakeTasteTag.create!(sake: sake, taste_tag: tag)
          Rails.logger.debug "TasteTag linked: #{tag.name}"
        end
        Rails.logger.debug "=== SakeForm: transaction complete ==="
      end
      true
    rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error "Transaction failed: #{e.message}"
      false
    end
  end
