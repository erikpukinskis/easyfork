class Invite < ActiveRecord::Base
  after_initialize :create_key

  def create_key
    self.key ||= (rand*10**10).to_i.to_s(26)
  end
end
