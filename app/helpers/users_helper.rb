require 'digest/md5'

module UsersHelper
  def gravatar_url(user)
    hash = Digest::MD5.hexdigest(@user.email.downcase)
    "http://www.gravatar.com/avatar/" << hash << ".jpg"
  end
end
