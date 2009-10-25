class User < ActiveRecord::Base
  attr_accessor :session_id
  has_many :apps, :foreign_key => 'owner_id'

  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end # block optional

  def User.identified_by_session(session_id)
    User.new(:session_id => session_id)
  end

  def adopt(orphans)
    orphans.each {|orphan| apps << App.find_by_id(orphan)}
  end
end
