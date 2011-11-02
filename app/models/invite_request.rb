class InviteRequest < ActiveRecord::Base
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates_length_of :why, :minimum => 10, :too_short => "should you get access to Forkolator?"

  def grant
    Invite.create
  end
end
