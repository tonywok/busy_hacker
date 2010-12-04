require 'uri'

get '/' do
  haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :style
end
