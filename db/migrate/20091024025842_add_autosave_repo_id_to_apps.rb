class AddAutosaveRepoIdToApps < ActiveRecord::Migration
  def self.up
    add_column :apps, :autosave_repo_id, :string
  end

  def self.down
    remove_column :apps, :autosave_repo_id
  end
end
