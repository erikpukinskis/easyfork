class FilesController < ApplicationController
  def update
    app = App.basic_find(params[:owner_id], params[:name])
    require_owner(app, current_user)
    app.save_file(params[:filename], params[:app_code])
    app.autosave_commit("autosaved #{params[:filename]}")
    render :json => {:status => :ok, :num_commits => app.commits.length,
      :changes_since_last_full_commit => app.changes_since_last_full_commit.length,
      :commits => app.commits_hash}
  end
end
