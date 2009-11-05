class SiteController < ApplicationController
  def home
    @invite_request = InviteRequest.new
    @user_session = UserSession.new
  end

  def thanks
    
  end
end
