class User < ActiveRecord::Base
  attr_accessor :session_id
  has_many :apps, :foreign_key => 'owner_id'
  has_many :stories

  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end # block optional

  def User.identified_by_session(session_id)
    User.new(:session_id => session_id)
  end

  def adopt(orphans)
    orphans.each {|orphan| apps << App.find_by_id(orphan)}
  end

  def to_param
    login
  end

  def add_story(text)
    stories << Story.new(:body => text, :date => Time.now)
  end
end
