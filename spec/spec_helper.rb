require 'bundler'
Bundler.require

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each {|file| require file }

require File.join(File.dirname(__FILE__), '..', 'busy_hacker.rb')

set :environment, :test
