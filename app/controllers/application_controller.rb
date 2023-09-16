class ApplicationController < ActionController::Base
  include CategoriesHelper
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :update_allowed_parameters, if: :devise_controller?

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |user| user.permit(:name, :email, :password, :avatar) }
    devise_parameter_sanitizer.permit(:account_update) do |user|
      user.permit(:name, :email, :password, :current_password, :avatar)
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      categories_path
    else
      root_path
    end
  end
end
