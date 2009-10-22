class FilesController < ApplicationController
  def update
    app = App.find_by_id(params[:app_id])
    require_owner(app, current_user)
    app.save_file(params[:id], params[:app_code])
    render :json => {:status => :ok}
  end
end
