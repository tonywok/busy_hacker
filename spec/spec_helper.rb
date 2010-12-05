require 'bundler'
Bundler.require

Sinatra::Application.environment = :test

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each {|file| require file }

require File.join(File.dirname(__FILE__), '..', 'busy_hacker.rb')
