class BadgeGrantService
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    grant_sake_count_badge
  end

  private

  attr_reader :user

  def grant_sake_count_badge
    count = user.sakes.count

    badges = Badge.where(condition_type: "sake_count")

    badges.each do |badge|
      next if badge.condition_value.blank?
      next if count < badge.condition_value

      grant_badge(badge)
    end
  end

  def grant_badge(badge)
    return if user.badges.exists?(badge.id)

    user.user_badges.create!(badge: badge)
  end
end
