require 'restclient'
require 'json'

class Forkolator
  @base = ENV['forkserver'] or "http://localhost:3001"

  def Forkolator.post(path, params)
    text = RestClient.post("#{@base}#{path}", params)
    JSON.parse(text)
  end

  def Forkolator.get(path)
    RestClient.get("#{@base}#{path}")
  end

  def Forkolator.get_json(path)
    JSON.parse(Forkolator.get(path))
  end
end
