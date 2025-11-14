class SakesController < ApplicationController
  before_action :authenticate_user!

  def index
    @sakes = Sake.all.includes(label_image_attachment: :blob)
  end

  def new
    @sake_form = SakeForm.new(user: current_user)
  end

  def create
    @sake_form = SakeForm.new(sake_form_params)
    @sake_form.user = current_user
    if @sake_form.save
      redirect_to sakes_path, notice: "日本酒を登録しました。"
    else
      flash.now[:alert] = "登録に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @sake = Sake.find(params[:id])
    @brewery = @sake.brewery
    @prefecture = @brewery.prefecture
    @taste_tags = @sake.taste_tags
  end

  def edit
    @sake = Sake.find(params[:id])
    @sake_form = SakeForm.new({}, sake: @sake)
  end
  
  def update
    
    @sake = Sake.find(params[:id])
    @sake_form = SakeForm.new(sake_form_params, sake: @sake)
    Rails.logger.debug "=== SakeForm Params ==="
    Rails.logger.debug sake_form_params.inspect
    if @sake_form.update(@sake)
      Rails.logger.debug "=== Update SUCCESS ==="
      Rails.logger.debug @sake.reload.attributes.inspect
      redirect_to sake_path(@sake), notice: "日本酒を更新しました。"
    else
      Rails.logger.debug "=== Update FAILED ==="
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def sake_form_params
    params.require(:sake_form).permit(:name, :brewery_name, :prefecture_id, :sake_meter_value, :rating, :comment, :label_image, :taste_tags)
  end
end
