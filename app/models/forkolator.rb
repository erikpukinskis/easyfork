require 'restclient'
require 'json'

class Forkolator
  @base = "http://ec2-67-202-60-46.compute-1.amazonaws.com"

  def Forkolator.post(path, params)
    text = RestClient.post("#{@base}#{path}", params)
    JSON.parse(text)
  end

  def Forkolator.get(path)
    RestClient.get("#{@base}#{path}")
  end
end
