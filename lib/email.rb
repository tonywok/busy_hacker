require './lib/base_model'
require './lib/validations'

class Email < BaseModel
  attr_accessor :address

  must_be_unique :address

  def initialize(attrs = {})
    self.address = attrs[:address] || ""
    super
  end

end
