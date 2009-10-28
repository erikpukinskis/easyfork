class CommitsController < ApplicationController
  def show
    app = App.basic_find(params[:owner_id], params[:name])
    sha = app.autosaves[params[:index].to_i]["sha"]
    render :json => {:text => app.old_code(sha), :index => params[:index].to_i}
  end

  def create
    app = App.basic_find(params[:owner_id], params[:name])
    app.do_commit(params['message'])
    render :json => {'status' => 'ok', :commits => app.commits_hash}
  end

  def index
    app = App.basic_find(params[:owner_id], params[:name])
    render :json => {:changes_since_last_full_commit => app.changes_since_last_full_commit.length,
      :total_changes => app.autosaves.length, :commits => app.commits_hash}
  end
end
