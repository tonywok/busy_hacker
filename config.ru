require 'sinatra'
require 'bundler'

Bundler.require

require './busy_hacker'

run Sinatra::Application
