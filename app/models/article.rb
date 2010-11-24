class Article
  include Mongoid::Document
  field :url, :type => String
  field :score, :type => Integer
  field :title, :type => String
  field :hacker_id, :type => Integer
end
