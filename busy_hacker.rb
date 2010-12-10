require 'uri'
require 'open-uri'
require './lib/scraper'
require './lib/email'

configure do
  environment = ENV['RACK_ENV'] || Sinatra::Application.environment


  if connection_str = ENV['MONGOHQ_URL']
    uri  = URI.parse(connection_str)
    conn = Mongo::Connection.from_uri(connection_str)
    DATABASE = conn.db(uri.path.gsub(/^\//, ''))
    DATABASE.authenticate(uri.user, uri.password)

    Pony.options = { :from => 'noreply@busyhacker.com', :via => :smtp, :via_options => {
      :address        => 'smtp.sendgrid.net',
      :port           => 25,
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => ENV['SENDGRID_DOMAIN']}
    }
    raise ENV['SENDGRID_PASSWORD'].to_s
  else
    conn = Mongo::Connection.from_uri('mongodb://localhost')
    DATABASE = conn.db("busyhacker_#{environment}")

    Pony.options = { :from => 'noreply@busyhacker.com' }
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
  email = Email.new(:address => params[:address])
  if email.valid?
    Email.collection.insert({"address" => email.address})
    @message = "Thanks, confirmation email on its way!"
    Pony.mail(:to => 'tsnydermtg@gmail.com', :subject => "Hi", :body => 'whatup?')
  else
    @message = "The email you provided was invalid"
  end

  haml :index
end

get '/scrape' do
  Scraper.scrape_hn
end
