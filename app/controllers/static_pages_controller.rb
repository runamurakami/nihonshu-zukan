class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [ :top ]

  def landing
    redirect_to top_path if user_signed_in?
  end
  def top
    @recent_sakes = current_user.sakes.order(created_at: :desc).limit(5)

    months = (0..5).map { |i| i.months.ago.beginning_of_month }.reverse
    counts = current_user.sakes
      .where(created_at: 6.months.ago.beginning_of_month..Time.current)
      .group("DATE_TRUNC('month', created_at)")
      .count
    @sake_counts_by_month = months.map do |month|
      [ month, counts[month] || 0 ]
      end.to_h

    @tag_counts = current_user.sakes
      .joins(:taste_tags)
      .group("taste_tags.name")
      .order("count_all DESC")
      .count
  end
end
