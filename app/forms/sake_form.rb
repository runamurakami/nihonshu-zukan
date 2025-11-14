class SakeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :sake, :name, :brewery_name, :prefecture_id, :sake_meter_value,
                :rating, :taste_tags, :label_image, :comment, :user

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
      # label_image は attach されたまま表示される
    end

    super(attributes)
  end

  # 新規登録
  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      brewery = Brewery.find_or_create_by!(name: brewery_name, prefecture_id: prefecture_id)
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

    ActiveRecord::Base.transaction do
      brewery = Brewery.find_or_create_by!(name: brewery_name, prefecture_id: prefecture_id)

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
end