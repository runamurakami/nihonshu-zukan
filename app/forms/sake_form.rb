class SakeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :sake, :name, :brewery_name, :prefecture_id, :sake_meter_value,
                :rating, :taste_tags, :label_image, :comment, :user,
                :sake_meter_sign, :sake_meter_number, :status

  validates :name, :brewery_name, presence: true
  validates :sake_meter_sign, :sake_meter_number, presence: true, if: :published?
  validates :rating,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 },
    if: :published?

  # 新規作成 or 編集時に既存データをセット
  def initialize(attributes = {}, sake: nil, user: nil, **kwargs)
    attributes = attributes.merge(kwargs)

    self.sake = sake
    self.user = user

    if sake
      self.name = attributes[:name].presence || sake.name
      self.brewery_name = attributes[:brewery_name].presence || sake.brewery.name
      self.prefecture_id = attributes[:prefecture_id].presence || sake.brewery.prefecture_id
      self.sake_meter_value = attributes[:sake_meter_value].presence || sake.sake_meter_value
      self.rating = attributes[:rating].presence || sake.rating
      self.taste_tags = attributes[:taste_tags] || sake.taste_tags.pluck(:name).join("、")
      self.comment = attributes[:comment].presence || sake.comment
      self.status = attributes[:status].presence || sake.status

      split_sake_meter
    else
      self.status = attributes[:status]
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
        status: status,
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
        comment: comment,
        status: status
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

  def published?
    status == "published"
  end

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
