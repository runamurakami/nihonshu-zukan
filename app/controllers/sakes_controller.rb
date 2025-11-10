class SakesController < ApplicationController
  before_action :authenticate_user! 

  def index
    @sakes = Sake.all.includes(label_image_attachment: :blob)
  end
  
  def new
    @sake = Sake.new
  end

  def create
    @sake = current_user.sakes.build(sake_params)
    if @sake.save
      redirect_to root_path, notice: "日本酒を登録しました。"
    else
      flash.now[:alert] = "登録に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sake_params
    params.require(:sake).permit(:name, :brewery_name, :prefecture_name, :sake_meter_value, :rating, :taste_tag_name, :comment, :label_image)
  end
end
