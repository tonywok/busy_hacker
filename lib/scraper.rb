require 'open-uri'

class Scraper

  def self.articles
    @articles ||= DATABASE.collection('articles')
  end

  def self.scrape_hn

    doc = Nokogiri::HTML(open('http://news.ycombinator.com'))

    doc.xpath('//table')[2].children.each_slice(3).each do |data_block|
      score_row = data_block[1]
      span      = score_row.css('span')[0]

      if span
        hacker_id = span.attr(:id).gsub('score_', '').to_i
        score     = span.children.text.gsub(' points', '').to_i

        require 'ruby-debug'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger


        puts "\n\n\n********************"
        puts "Hacker id: #{hacker_id}"
        puts "Score    : #{score}"

        # if article
        #   article.update_attributes(:score => score)
        # else
          link    = data_block[0].css('a:first').last
          url     = link.attr(:href)
          title   = link.children.to_s

          articles.insert({url: url, title: title, score: score, hacker_id: hacker_id})

          # Article.create(:score => score, :title => title, :url => url, :hacker_id => hacker_id)
          puts "Url   : #{url}"
          puts "Title : #{title}"
        # end
      end
    end
  end

end
