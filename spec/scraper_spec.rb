require File.dirname(__FILE__) + '/spec_helper'

describe Scraper do
  describe "Scraper#articles" do
    it 'has access to scraper collection' do
      Scraper.articles.should be_a(Mongo::Collection)
    end
  end

  describe "Scraper#scrape_hn"do
    before do
      hn_frontpage = File.open("spec/data/hacker_news_site.html")
      data = Nokogiri::HTML(open(hn_frontpage))
      Scraper.should_receive(:parse_file).and_return(data)
    end

    context 'when scraping data off of HN for the first time' do
      it 'creates 30 documents' do
        Scraper.scrape_hn
        Scraper.articles.count().should == 30
      end
    end
  end

  context 'when an article is already in the db' do
    let(:doc) { {score: 40,
                 title: 'Google buys Busy Hacker for 1.3 Billion',
                 url: 'www.tonyschneider.com',
                 hacker_id: 3} }
    before do
      Scraper.articles.drop()
      Scraper.articles.insert(doc)
    end
    after  { Scraper.articles.drop() }

    it 'can find the document' do
      article = Scraper.articles.find({hacker_id: 3}).first
      article['score'].should == 40
    end

    it 'updates the document' do
      article = Scraper.articles.find({hacker_id: 3}).first
      Scraper.articles.update({"_id" => article['_id']}, {'$set' => {'score' => 30}})
      article = Scraper.articles.find({hacker_id: 3}).first
      article['score'].should == 30
    end
  end

  context 'when an article is new' do
    let(:doc) { {score: 40,
                 title: 'Google buys Busy Hacker for 1.3 Billion',
                 url: 'www.tonyschneider.com',
                 hacker_id: 3} }
    before { Scraper.articles.drop() }
    after  { Scraper.articles.drop() }

    it 'inserts the document' do
      Scraper.articles.insert(doc)
      Scraper.articles.count.should == 1
    end
  end
end
