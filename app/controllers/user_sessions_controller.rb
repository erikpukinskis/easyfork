class UserSessionsController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
#  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end

  def new_user_session_url
    '/signin'
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if session[:orphan_apps]
        current_user.adopt(session[:orphan_apps]) 
        session[:orphan_apps] = []
      end
      redirect_back_or_default '/'
    else
      render :action => :new
    end
  end
  
  def destroy
    if current_user_session
      current_user_session.destroy
      flash[:notice] = "You are signed out!"
    end
    redirect_back_or_default new_user_session_url
  end
end
