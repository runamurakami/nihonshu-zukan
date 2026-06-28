class SakesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sake, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :show, :edit, :update, :destroy ]

  def index
    @q = current_user.sakes.published.includes(:brewery, brewery: :prefecture, label_image_attachment: :blob).ransack(params[:q])
    @sakes = @q.result(distinct: true).page(params[:page])
  end

  def drafts
    @q = current_user.sakes.draft.includes(:brewery, brewery: :prefecture, label_image_attachment: :blob).ransack(params[:q])
    @sakes = @q.result(distinct: true).page(params[:page])
  end

  def new
    @sake_form = SakeForm.new(user: current_user, status: params[:status])
  end

  def create
    @sake_form = SakeForm.new(sake_form_params)
    @sake_form.user = current_user
    if @sake_form.save
      BadgeGrantService.call(current_user)
      redirect_to sakes_path, notice: t("flash.sakes.create.success")
    else
      flash.now[:alert] = t("flash.sakes.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @sake = Sake.find(params[:id])
    @brewery = @sake.brewery
    @prefecture = @brewery.prefecture if @brewery&.prefecture_id.present?
    @taste_tags = @sake.taste_tags
  end

  def edit
    @sake = Sake.find(params[:id])
    @sake_form = SakeForm.new({}, sake: @sake)
  end

  def update
    @sake = Sake.find(params[:id])
    @sake_form = SakeForm.new(sake_form_params, sake: @sake)
    if @sake_form.update(@sake)
      redirect_to sake_path(@sake), notice: t("flash.sakes.update.success")
    else
      flash.now[:alert] = t("flash.sakes.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sake = Sake.find(params[:id])
    @sake.destroy
    redirect_to sakes_path, notice: t("flash.sakes.destroy.success")
  end

  def autocomplete
    query = params[:q].to_s.strip
    results =
      if query.present?
        current_user.sakes.where("name ILIKE ?", "%#{query}%").limit(5).pluck(:name)
      else
        []
      end
    render json: results
  end

  private

  def set_sake
    @sake = Sake.find(params[:id])
  end

  def authorize_user!
    unless @sake.user == current_user
      flash[:alert] = t("flash.sakes.authorization.access_denined")
      redirect_to sakes_path
    end
  end

  def sake_form_params
    params.require(:sake_form).permit(:name, :brewery_name, :prefecture_id, :sake_meter_value, :sake_meter_sign, :sake_meter_number, :rating, :comment, :label_image, :taste_tags, :status)
  end
end
