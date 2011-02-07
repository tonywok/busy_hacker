require 'uri'
require 'open-uri'
require './lib/scraper'
require './lib/email'
require './lib/article'

configure do
  environment = Sinatra::Application.environment
  conn = Mongo::Connection.from_uri('mongodb://localhost')
  DATABASE = conn.db("busyhacker_#{environment}")
  Pony.options = { :from => 'noreply@busyhacker.com',
                   :via  => :sendmail }
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
  if email.valid?
    Email.collection.insert({"address" => email.address})
    if Sinatra::Application.environment :production
      Pony.mail(:to => email.address, :subject => "Busy Hacker", :body => '')
    end
  end
  redirect '/'
end

get '/scrape' do
  Scraper.scrape_hn
end
