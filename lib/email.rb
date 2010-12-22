class Email < BaseModel
  attr_accessor :address

  must_be_unique :address
  must_be_formatted :address, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  must_be_present :address

end
