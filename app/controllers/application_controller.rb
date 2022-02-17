class ApplicationController < ActionController::Base
  include Pagy::Backend
  
  protect_from_forgery with: :exception

protected

  def after_sign_in_path_for(user)
    user.admin? ? admin_courses_path : root_path
  end
end
