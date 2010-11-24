namespace :db do
  desc 'scrape hackernews front page for articles'
  task :scrape_hacker_news => [:environment] do
    @doc = Nokogiri::HTML(open('http://news.ycombinator.com'))

    @doc.xpath('//table')[2].children.each_slice(3).each do |data_block|
      score_row = data_block[1]
      span      = score_row.css('span')[0]
      if span
        hacker_id = span.attr(:id).gsub('score_', '').to_i
        score     = span.children.text.gsub(' points', '').to_i

        if article = Article.find_or_initialize_by(:hacker_id => hacker_id)
          article.update_attribute(:score, score)
        else
          link  = data_block[0].css('a:first').last
          title = link.attr(:href)
          link  = link.children.to_s
          Article.create(:score => score, :title => title, :link => link, :hacker_id => hacker_id)
        end
      end
    end
  end
end
