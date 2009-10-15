class App < ActiveRecord::Base
  attr_accessor :code
  belongs_to :owner, :class_name => "User"

  def to_s
    name or "Untitled"
  end

  def before_create
    response = Forkolator.post('/repos', {})
    self.identifier = response['repo_id']
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
