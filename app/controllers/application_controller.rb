class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_up_path_for(resource)
    case resource
    when User
      user_genres_path(current_user)
    end
  end

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_root_path
    when User
      user_genres_path(current_user)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
    when :admin
      new_admin_session_path
    when :user
      root_path
      end
    end

  # 動的に404エラーページを表示するための処理
  unless Rails.env.development?
    rescue_from Exception,                      with: :render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end



  def routing_error
    raise ActionController::RoutingError, params[:path]
  end


  def render_404
    render 'error/404', status: :not_found
  end

  def render_500
    render 'error/500', status: :internal_server_error
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
