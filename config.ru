require 'sinatra'
require 'bundler'

Bundler.require

require './lib/monglet'
require './busy_hacker'

run Sinatra::Application
