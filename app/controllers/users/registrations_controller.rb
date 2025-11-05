# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # 新規登録後にリダイレクトする先を指定
  def after_sign_up_path_for(resource)
    new_user_session_path
  end
end
