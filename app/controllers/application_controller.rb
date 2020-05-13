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
	    	admin_users_path
	    end
    end


	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
	end

end
