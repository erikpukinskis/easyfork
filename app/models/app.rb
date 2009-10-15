class App < ActiveRecord::Base
  def getcode

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
