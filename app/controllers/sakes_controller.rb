class SakesController < ApplicationController
  before_action :authenticate_user!

  def index
    @sakes = Sake.all.includes(label_image_attachment: :blob)
  end

  def new
    @sake_form = SakeForm.new
  end

  def create
    @sake_form = SakeForm.new(sake_form_params)
    @sake_form.user = current_user
    if @sake_form.save
      redirect_to root_path, notice: "日本酒を登録しました。"
    else
      flash.now[:alert] = "登録に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @sake = Sake.find(params[:id])
  end

  private

  def sake_form_params
    params.require(:sake_form).permit(:name, :brewery_name, :prefecture_id, :sake_meter_value, :rating, :comment, :label_image, taste_tags: [])
  end
end
