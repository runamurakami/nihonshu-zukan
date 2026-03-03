class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [ :top ]

  def landing
    redirect_to top_path if user_signed_in?
  end
  def top
    @recent_sakes = current_user.sakes.order(created_at: :desc).limit(5)
  end
end
