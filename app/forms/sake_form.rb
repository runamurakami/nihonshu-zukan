class SakeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :sake, :name, :brewery_name, :prefecture_id, :sake_meter_value,
                :rating, :taste_tags, :label_image, :comment, :user,
                :sake_meter_sign, :sake_meter_number

  validates :name, :brewery_name, presence: true

  # 新規作成 or 編集時に既存データをセット
  # attributes が空の場合のみ sake の値で初期化
  def initialize(attributes = {}, sake: nil, user: nil)
    self.sake = sake
    self.user = user

    if sake && attributes.blank?
      self.name = sake.name
      self.brewery_name = sake.brewery.name
      self.prefecture_id = sake.brewery.prefecture_id
      self.sake_meter_value = sake.sake_meter_value
      self.rating = sake.rating
      self.taste_tags = sake.taste_tags.pluck(:name).join("、")
      self.comment = sake.comment

      split_sake_meter
    end

    super(attributes)
  end

  # 新規登録
  def save
    return false unless valid?

    combine_sake_meter

    ActiveRecord::Base.transaction do
      brewery = Brewery.find_or_create_by!(name: brewery_name)
      # pref_id がある場合だけ代入
      brewery.update(prefecture_id: prefecture_id) if prefecture_id.present?
      new_sake = Sake.new(
        name: name,
        brewery: brewery,
        sake_meter_value: sake_meter_value,
        rating: rating,
        comment: comment,
        user: user
      )
      new_sake.label_image.attach(label_image) if label_image.present?
      new_sake.save!

      attach_tags(new_sake)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  # 更新
  def update(target_sake)
    return false unless valid?
    return false unless target_sake.present?

    combine_sake_meter

    ActiveRecord::Base.transaction do
      brewery = Brewery.find_or_create_by!(name: brewery_name)
      # pref_id がある場合だけ代入
      brewery.update(prefecture_id: prefecture_id) if prefecture_id.present?

      target_sake.update!(
        name: name,
        brewery: brewery,
        sake_meter_value: sake_meter_value,
        rating: rating,
        comment: comment
      )

      if label_image.present?
        target_sake.label_image.purge if target_sake.label_image.attached?
        target_sake.label_image.attach(label_image)
      end

      # タグ更新
      target_sake.sake_taste_tags.destroy_all
      attach_tags(target_sake)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def attach_tags(target_sake)
    tag_names = taste_tags.to_s.split(/[,\u3001]/).map(&:strip).reject(&:blank?)
    tag_names.each do |tag_name|
      tag = TasteTag.find_or_create_by!(name: tag_name)
      SakeTasteTag.create!(sake: target_sake, taste_tag: tag)
    end
  end

  def split_sake_meter
    return if sake_meter_value.blank?
  
    self.sake_meter_sign =
      sake_meter_value.start_with?("-") ? "-" : "+"
  
    self.sake_meter_number =
      sake_meter_value.delete("+-")
  end

  def combine_sake_meter
    return if sake_meter_sign.blank? && sake_meter_number.blank?
  
    self.sake_meter_value = "#{sake_meter_sign}#{sake_meter_number}"
  end
end
