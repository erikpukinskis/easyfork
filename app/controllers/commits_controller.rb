class CommitsController < ApplicationController
  def show
    app = App.find_by_id(params[:app_id])
    sha = app.commits[params[:id].to_i]["sha"]
    render :json => {:text => app.old_code(sha), :index => params[:id].to_i}
  end

  def create
    app = App.find_by_id(params[:app_id])
    app.do_commit(params['message'])
    render :json => {'status' => 'ok'}
  end
end
