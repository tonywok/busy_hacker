require 'uri'
require 'open-uri'
require './lib/scraper'
require './lib/email'
require './lib/article'
require 'logger'

configure do
  environment = Sinatra::Application.environment
  conn = Mongo::Connection.from_uri('mongodb://localhost')
  DATABASE = conn.db("busyhacker_#{environment}")
  Pony.options = { :from => 'noreply@busyhacker.com',
                   :via  => :sendmail }
  @@log = Logger.new("./log/#{environment}.log")
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
  @@log.info("attempt email subscription for: #{email}")
  if email.valid?
    @@log.info("email valid?: #{email.valid?}")
    @@log.info(`which sendmail`)
    Email.collection.insert({"address" => email.address})
    if Sinatra::Application.environment == :production
      attempt = Pony.mail(:to => email.address, :subject => "Busy Hacker", :body => '')
      @@log.info("wtf?: #{attempt}")
    end
  end
  redirect '/'
end

get '/scrape' do
  Scraper.scrape_hn
  redirect '/'
end
