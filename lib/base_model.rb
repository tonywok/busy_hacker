require './lib/validations'

class BaseModel
  include Validations

  attr_accessor :errors

  def self.collection
    DATABASE.collection("#{self.to_s.downcase}s")
  end

  def initialize(attrs = {})
    self.errors = attrs[:errors] || []
  end

end
