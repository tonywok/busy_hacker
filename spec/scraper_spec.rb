require File.dirname(__FILE__) + '/spec_helper'

describe Scraper do
  it 'has access to scraper collection' do
    Scraper.articles.should be_a(Mongo::Collection)
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
