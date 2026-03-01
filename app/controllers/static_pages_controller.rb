class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [ :top ]

  def landing
    redirect_to top_path if user_signed_in?
  end
  def top; end
end
