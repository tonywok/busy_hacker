require File.dirname(__FILE__) + '/../spec_helper'

describe Article do
  before { Article.collection.drop() }
  after { Article.collection.drop() }

  describe 'validations' do
    let(:article) { Article.new }
    context 'hacker_id' do
      it 'is present' do
        article.valid?
        article.errors.should include('That hacker_id is required')
      end

      it 'is unique' do
        Article.collection.insert({hacker_id: 2, title: 'test', url: 'google.com', score: 23, date_added: Time.now})
        article = Article.new(:hacker_id => 2)
        article.valid?
        article.errors.should include('That hacker_id has already been taken')
      end

      it 'is an integer' do
        article = Article.new(:hacker_id => "face")
        article.valid?
        article.errors.should include('That hacker_id is not an integer')
      end
    end

    context 'score' do
      it 'is present' do
        article.valid?
        article.errors.should include('That score is required')
      end

      it 'is an integer' do
        article = Article.new(:score => "face")
        article.valid?
        article.errors.should include('That score is not an integer')
      end
    end

    context 'url' do
      it 'is present' do
        article.valid?
        article.errors.should include('That url is required')
      end
    end
  end

  describe 'Article#top' do
    context 'determining the number of results' do
      before { 10.times { |i| insert_scored_article(rand(i)) }}
      it 'finds the top X articles' do
        Article.top(5).count(true).should == 5
      end
    end

    context 'ordering the top articles' do
      before { 5.times {|i| insert_scored_article(i)} }
      it 'is ordered by score' do
        scores = Article.top(5).collect { |article| article['score'] }
        scores.should == [4,3,2,1,0]
      end
    end
  end

  describe 'Article#within_a_week' do
    before { 5.times {|i| insert_article_from_past_week(i) } }
    it 'only grabs articles from current week' do
      times = Article.within_a_week.collect { |article| article['date_added'] }
      times.each do |time|
        time.should be > (Time.now - Article::LENGTH_OF_WEEK_IN_SEC)
        time.should be < Time.now
      end
    end
  end

  def insert_scored_article(num)
    Article.collection.insert({hacker_id: 2, title: 'test', url: 'google.com',
                               score: num, date_added: Time.now})
  end

  def insert_article_from_past_week(num)
    Article.collection.insert({hacker_id: 2, title: 'test', url: 'google.com',
                               score: num, date_added: Time.now - (num*Article::LENGTH_OF_WEEK_IN_SEC)})
  end
end
