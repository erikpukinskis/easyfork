class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.text :body
      t.datetime :date
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
