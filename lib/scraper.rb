require 'open-uri'

def hacker_news
  doc = Nokogiri::HTML('http://news.ycombinator.com')

  doc.xpath('//table')[2].children.each_slice(3).each do |data_block|
    score_row = data_block[1]
    span      = score_row.css('span')[0]

    if span
      hacker_id = span.attr(:id).gsub('score_', '').to_i
      score     = span.children.text.gsub(' points', '').to_i
      article   = Article.find(:first, :conditions => {:hacker_id => hacker_id})
      article   = DATABASE.emails.find({'hacker_id':hacker_id})

      if article
        article.update_attributes(:score => score)
      else
        link    = data_block[0].css('a:first').last
        url     = link.attr(:href)
        title   = link.children.to_s
        Article.create(:score => score, :title => title, :url => url, :hacker_id => hacker_id)
      end
    end
  end
end


