class CommitsController < ApplicationController
  def show
    app = App.find_by_id(params[:app_id])
    sha = app.commits[params[:id].to_i]["sha"]
    render :text => app.old_code(sha)
  end
end
