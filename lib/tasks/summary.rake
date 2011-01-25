require 'bundler'
Bundler.require
require './lib/monglet'
require './busy_hacker'

task :default => :summary

task :summary do
  email_body = generate_body(top_ten_articles = Article.top_10_for_week)

  if top_ten_articles.count(true) == 10
    Email.collection.find.each do |email|
      Pony.mail(:to      => email['address'],
                :subject => "Top 10 Hacker News articles for the week of #{Date.today}",
                :body    => email_body)
    end
  end
end

def generate_body(articles)
  text = <<-GREETING
    \n Greetings fellow hacker,

    Here are your top 10 articles from Hacker News this week. Read 'em quick and get back to hacking!

    - Tony (@tonywok)\n\n
  GREETING

  articles.each_with_index do |article, index|
    text += "#{index + 1}. <a href='#{article['url']}'>#{article['title']}</a>\n"
    text += "\tUp votes: #{article['score']}\n\n"
  end
  text
end
