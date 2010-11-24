class Article
  include Mongoid::Document
  field :url, :type => String
  field :score, :type => Integer
  field :title, :type => String
  field :hacker_id, :type => Integer

  validates_presence_of :url, :score, :title, :hacker_id
  validates_format_of :url, :with => /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
  validates_uniqueness_of :hacker_id
end
