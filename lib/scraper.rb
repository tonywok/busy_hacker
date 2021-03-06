require 'open-uri'

class Scraper

  def self.articles
    @articles ||= DATABASE.collection('articles')
  end

  def self.scrape_hn
    doc = parse_file

    doc.xpath('//table')[2].children.each_slice(3).each do |data_block|
      a_week_ago  = Time.now - Article::LENGTH_OF_WEEK_IN_SEC
      score_row = data_block[1]
      span      = score_row.css('span')[0]

      if span
        hacker_id = span.attr(:id).gsub('score_', '').to_i
        score     = span.children.text.gsub(' points', '').to_i
        article   = articles.find({hacker_id: hacker_id}).first

        if article
          if article['date_added'] < a_week_ago
            Scraper.articles.update({'_id' => article['_id']}, {'$set' => {'score' => score}})
          end
        else
          link    = data_block[0].css('a:first').last
          url     = link.attr(:href)
          title   = link.children.to_s
          articles.insert({url: url, title: title, score: score, hacker_id: hacker_id, date_added: Time.now})
        end
      end
    end
  end

  private

  def self.parse_file
    Nokogiri::HTML(open('http://news.ycombinator.com'))
  end

end
