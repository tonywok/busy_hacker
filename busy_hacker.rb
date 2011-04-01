require 'uri'
require 'open-uri'
require './lib/scraper'
require './lib/email'
require './lib/article'
require 'aws/ses'

configure do
  environment = Sinatra::Application.environment
  conn = Mongo::Connection.from_uri('mongodb://localhost')
  DATABASE = conn.db("busyhacker_#{environment}")
  keys = YAML.load_file('.ses_keys')
  set :ses_key_id, keys['ses_id']
  set :ses_secret, keys['ses_secret']
end

get '/' do
  @top_articles = Article.top_10_for_week
  haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :style
end

post '/subscribe' do
  email = Email.new(:address => params[:address])
  email.subscribe if email.valid?
  redirect '/'
end

get '/scrape' do
  Scraper.scrape_hn
  redirect '/'
end

get '/email_confirmation' do
  token = params[:token]
  Email.confirm!(token)
  redirect '/'
end
