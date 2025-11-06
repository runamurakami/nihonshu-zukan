# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # サインイン直後やサインアップ直後の遷移先を指定
  def after_sign_in_path_for(resource)
    # サインアップ直後にもここが呼ばれるケースがある
    stored_location_for(resource) || root_path
  end

  # 新規登録後にリダイレクトする先を指定
  def after_sign_up_path_for(resource)
    sign_out(resource)
    new_user_session_path
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
end
