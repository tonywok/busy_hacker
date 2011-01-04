class BaseModel
  include Validations

  attr_accessor :errors

  def self.collection
    @collection = DATABASE.collection("#{self.to_s.downcase}s")
  end

  def initialize(attrs = {})
    self.errors = attrs[:errors] || []
    attrs.each do |attr, val|
      self.send("#{attr}=", val)
    end
  end

end
