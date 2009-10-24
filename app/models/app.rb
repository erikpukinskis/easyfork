class App < ActiveRecord::Base
  attr_accessor :code
  belongs_to :owner, :class_name => "User"

  def to_s
    name or "Untitled"
  end

  def before_create
    response = Forkolator.post('/repos', {})
    self.identifier = response['repo_id'] unless identifier
  end

  def save_file(filename, content)
    Forkolator.post("/repos/#{identifier}/files/#{filename}", {:content => content})
  end

  def deploy
    response = Forkolator.post("/repos/#{identifier}/deploy", {})
    if response['uri']
      update_attributes(:uri => response['uri'])
    end
  end

  def getcode
    @code ||= (Forkolator.get("/repos/#{identifier}/files/app.rb") if identifier)
  end

  def commits
    @commits ||= JSON.parse(Forkolator.get("/repos/#{identifier}/commits"))
  end

  def do_commit(message)
    Forkolator.post("/repos/#{identifier}/commits", {:message => message})
  end

  def old_code(sha)
    Forkolator.get("/repos/#{identifier}/trees/#{sha}/raw/app.rb")
  end

  def fork(user)
    response = Forkolator.post("/repos/#{identifier}/fork", {})
    app = App.create!(:owner_id => user.id, :identifier => response['repo_id'])
    app
  end

  def save_sinatra_rackup
    save_file('config.ru', "  
      require 'app'
      run Sinatra::Application")
  end

  def code
    getcode || <<EOS
require 'rubygems'
require 'sinatra'

get '/' do
  "hello world!"
end
EOS
  end
end
