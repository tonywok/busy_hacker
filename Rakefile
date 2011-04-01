require 'bundler'
Bundler.require
require './lib/mailer'
require './lib/monglet'
require './busy_hacker'
require 'logger'

task :default => :summary

desc "sends emails to Busy Hacker subscribers"
task :summary do
  log = Logger.new("./log/#{Sinatra::Application.environment}.log")
  email_body = generate_body(top_ten_articles = Article.top_10_for_week)

  if top_ten_articles.count(true) == 10
    mail = Mailer.new
    Email.collection.find({'verified' => true}).each do |email|
      log.info("Trying to send email to: #{email['address']}")
      mail.send(:to => email['address'],
                :subject => "Top 10 Hacker News articles for the week of #{Date.today.strftime("%m/%d/%y")}",
                :body => email_body)
    end
  end
end

def generate_body(articles)
  text = <<-GREETING
    Greetings fellow hacker,

    Here are your top 10 articles from Hacker News this week. Read 'em quick and get back to hacking!

    - Tony (@tonywok)\n\n
  GREETING

  articles.each_with_index do |article, index|
    text += "#{index + 1}. #{article['title']}\n\t#{article['url']}\n\n"
  end
  text
end

