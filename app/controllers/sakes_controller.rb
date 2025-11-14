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
    @brewery = @sake.brewery
    @prefecture = @brewery.prefecture
    @taste_tags = @sake.taste_tags
  end

  def edit
    @sake = Sake.find(params[:id])
    @sake_form = SakeForm.new(
      name: @sake.name,
      brewery_name: @sake.brewery.name,
      prefecture_id: @sake.brewery.prefecture_id,
      sake_meter_value: @sake.sake_meter_value,
      rating: @sake.rating,
      taste_tags: @sake.taste_tags.pluck(:name).join("、"),
      comment: @sake.comment,
      label_image: @sake.label_image
    )
  end

  def update
    @sake = Sake.find(params[:id])
    @sake_form = SakeForm.new(sake_form_params)

    if @sake_form.update(@sake)
      redirect_to @sake, notice: "日本酒情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def sake_form_params
    params.require(:sake_form).permit(:name, :brewery_name, :prefecture_id, :sake_meter_value, :rating, :comment, :label_image, :taste_tags)
  end
end
