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
end
