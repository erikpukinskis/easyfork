class AddNameToApps < ActiveRecord::Migration
  def self.up
    add_column :apps, :name, :string
  end

  def self.down
    remove_column :apps, :name
  end
end
