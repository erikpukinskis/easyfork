require 'json'

class App < ActiveRecord::Base
  attr_accessor :code
  belongs_to :owner, :class_name => "User"

  def to_s
    name or "Untitled"
  end

  def before_create
    repo = Forkolator.post('/repos', {})
    self.identifier = repo['repo_id'] unless identifier
    autosave_repo = Forkolator.post('/repos', {})
    self.autosave_repo_id = autosave_repo['repo_id']
  end

  def save_file(filename, content)
    Forkolator.post("/repos/#{identifier}/files/#{filename}", {:content => content})
    Forkolator.post("/repos/#{autosave_repo_id}/files/#{filename}", {:content => content})
  end

  def deploy
    response = Forkolator.post("/repos/#{identifier}/deploy", {})
    if response['uri']
      update_attributes(:uri => response['uri'])
    end
  end

  def getcode
    @code ||= (Forkolator.get("/repos/#{autosave_repo_id}/files/app.rb") if autosave_repo_id)
  end

  def commits
    @commits ||= if identifier
      JSON.parse(Forkolator.get("/repos/#{identifier}/commits"))
    else
      []
    end
  end

  def autosaves
    @autosaves ||= if autosave_repo_id
      JSON.parse(Forkolator.get("/repos/#{autosave_repo_id}/commits"))
    else
      []
    end
  end

  def commits_hash
    full = commits.map do |commit| 
      commit['real_full'] = true
      commit
    end
    all = full + autosaves
    all = all.sort {|a,b| a['date'] <=> b['date']}

    (1..all.count-1).each do |i|
      if all[i]['real_full']
        all[i-1]["full"] = true
        all[i-1]["message"] = all[i]["message"]
      end
    end

    all.delete_if {|commit| commit['real_full']}
  end

  def changes_since_last_full_commit
    last_commit = commits.max {|a,b| a['date'] <=> b['date']}
    autosaves.inject([]) do |all,commit| 
      all << commit if commit['date'] > last_commit['date']
      all
    end
  end

  def do_commit(message)
    Forkolator.post("/repos/#{identifier}/commits", {:message => message})
  end

  def autosave_commit(message)
    Forkolator.post("/repos/#{autosave_repo_id}/commits", {:message => message})
  end

  def old_code(sha)
    Forkolator.get("/repos/#{autosave_repo_id}/trees/#{sha}/raw/app.rb")
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
