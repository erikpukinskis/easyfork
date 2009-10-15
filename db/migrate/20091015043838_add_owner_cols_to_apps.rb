class AddOwnerColsToApps < ActiveRecord::Migration
  def self.up
    add_column :apps, :owner_id, :integer
    add_column :apps, :session_id, :string
  end

  def self.down
    remove_column :apps, :session_id
    remove_column :apps, :owner_id
  end
end
