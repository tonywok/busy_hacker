require 'digest'
require './lib/mailer'

class Email < BaseModel
  attr_accessor :address, :verified, :confirm_token

  must_be_unique :address
  must_be_formatted :address, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  must_be_present :address

  def subscribe
    set_email_confirmation_token
    Email.collection.insert({"address"       => address,
                             "verified"      => false,
                             "confirm_token" => confirm_token})
    mail = Mailer.new
    mail.send(to: address, subject: 'Busy Hacker email confirmation', body: mail.confirmation_msg_for(self))
  end

  def self.confirm!(token)
    collection.update({"confirm_token" => token}, {'$set' => {'verified' => true}})
  end

  private

  def set_email_confirmation_token
    self.confirm_token = Digest::SHA2.hexdigest("!@##{Time.now}$%^")
  end

  def email_confirmation_message
    <<-MESSAGE
      Hey there,

      To get the weekly top 10 hottest Hacker News articles emailed to you
      in a newsletter, please confirm your email by clicking the following link.

      http://localhost:9393/email_confirmation?token=#{confirm_token}
    MESSAGE
  end
end
