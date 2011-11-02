# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Easyfork::Application.initialize!

# Optionally require the debugger
unless Rails.env == 'production'
  require 'ruby-debug'
  Debugger.start
  Debugger.settings[:autoeval] = true
end