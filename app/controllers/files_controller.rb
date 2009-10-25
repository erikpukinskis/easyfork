class FilesController < ApplicationController
  def update
    app = App.find_by_id(params[:app_id])
    require_owner(app, current_user)
    app.save_file(params[:id], params[:app_code])
    app.autosave_commit("autosaved #{params[:id]}")
    render :json => {:status => :ok, :num_commits => app.commits.count,
      :changes_since_last_full_commit => app.changes_since_last_full_commit.count,
      :commits => app.commits_hash}
  end
end
