class Article < BaseModel
  attr_accessor :hacker_id, :url, :title, :score, :date_added

  LENGTH_OF_WEEK_IN_SEC = 604800

  must_be_present :hacker_id
  must_be_present :url
  must_be_present :title
  must_be_present :score
  must_be_present :date_added

  must_be_number  :score, :integer => true
  must_be_number  :hacker_id, :integer => true

  must_be_unique  :hacker_id

  def self.top(num)
    Article.collection.find().limit(num).sort(:score, -1)
  end

  def self.within_a_week
    Article.collection.find({'date_added' => {'$gt' => Time.now - LENGTH_OF_WEEK_IN_SEC}})
  end

  ########################################
  ### Implement a Monglet Query object ###
  ### This is a combination of above   ###
  ### Kill it asap                     ###
  ########################################
  def self.top_10_for_week
    Article.collection.find({'date_added' => {'$gt' => Time.now - LENGTH_OF_WEEK_IN_SEC}}).
                       limit(10).
                       sort(:score, -1)
  end
end
