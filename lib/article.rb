require './lib/base_model'

class Article < BaseModel
  attr_accessor :hacker_id, :url, :title, :score, :date_added

  must_be_present :hacker_id
  must_be_present :url
  must_be_present :title
  must_be_present :score
  must_be_present :date_added

  must_be_number  :score, :integer => true
  must_be_number  :hacker_id, :integer => true

  must_be_unique  :hacker_id
end
