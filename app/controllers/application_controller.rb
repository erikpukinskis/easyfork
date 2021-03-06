# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '25bb4f57070f2e66a841638ea2387517'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  helper_method :current_user_session, :current_user, :signed_in?, :app_path, :app_link

  private
    def app_path(app, action = nil)
      if app.owner and app.name
        base = "/#{app.owner.login}/#{app.name}"
      else
        base = "/apps/#{app.id}"
      end
      base <<= "/" + action if action
      base
    end

    def app_link(app) 
      "<a href=\"#{app_path(app)}\">#{app}</a>"
    end

    ["commits", "fork", "deploy"].each do |action|
      define_method :"app_#{action}_path" do |app|
        app_path(app, action)
      end
      helper_method :"app_#{action}_path"
    end

    def signed_in?
      !!current_user
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page."
        redirect_to new_user_session_url
        return false
      end
    end

    def require_admin
      return if require_user === false
      unless current_user.admin
        store_location
        flash[:notice] = "You must be an administrator in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_owner(app, user)
      raise "You're not the owner of that app!" unless app.owner == user
    end
 
#    def require_no_user
#      if current_user
#        store_location
#        flash[:notice] = "You must be logged out to access this page"
#        redirect_to account_url
#        return false
#      end
#    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
