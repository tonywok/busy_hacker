require 'bundler'
Bundler.require

Sinatra::Application.environment = :test

# require monglet
require File.dirname(__FILE__) + '/../lib/monglet'

# require bunch-o-stuff from lib
Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each {|file| require file }

# require sinatra main
require File.join(File.dirname(__FILE__), '..', 'busy_hacker.rb')
