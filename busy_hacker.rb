require 'uri'
require 'open-uri'
require './lib/scraper'

configure do
  environment     = ENV['RACK_ENV'] || 'development'
  COLLECTION_NAME = ENV['BUSY_HACKER_COLLECTION'] || "#{environment}_emails"

  if connection_str = ENV['MONGOHQ_URL']
    uri  = URI.parse(connection_str)
    conn = Mongo::Connection.from_uri(connection_str)
    DATABASE = conn.db(uri.path.gsub(/^\//, ''))
    DATABASE.authenticate(uri.user, uri.password)
  else
    conn = Mongo::Connection.from_uri('mongodb://localhost')
    DATABASE = conn.db("busyhacker_#{environment}")
  end
end

get '/' do
  haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :style
end

post '/subscribe' do
  email = params[:email]
  coll = DATABASE.collection(COLLECTION_NAME)
  doc = {"email" => email}
  coll.insert(doc)
end

get '/scrape' do
  Scraper.scrape_hn
end
