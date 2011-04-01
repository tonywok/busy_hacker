require File.dirname(__FILE__) + '/../spec_helper'

describe Email do
  before { Email.collection.drop() }
  after { Email.collection.drop() }

  describe 'validations' do
    context 'address is unique' do
      it 'is invalid if address exists' do
        Email.collection.insert({address: 'tonywok@gmail.com'})
        email = Email.new(:address => 'tonywok@gmail.com')
        email.valid?
        email.errors.should include "That address has already been taken"
      end

      it 'is valid if address is unique' do
        email = Email.new(:address => 'tonywok@gmail.com')
        email.valid?.should be_true
      end
    end

    context 'address is formatted as an email' do
      it 'is invalid if not formatted as an email' do
        email = Email.new(:address => 'jiveturkey')
        email.valid?
        email.errors.should include 'That address is formatted incorrectly'
      end

      it 'is valid if it is formatted like an email' do
        email = Email.new(:address => 'jiveturkey@jammer.com')
        email.valid?.should be_true
      end
    end

    context 'address is a required field' do
      it 'is invalid if it is not present' do
        email = Email.new
        email.valid?
        email.errors.should include 'That address is required'
      end

      it 'is valid if it is present' do
        email = Email.new(:address => 'foo@bar.com')
        email.errors.should_not include 'That address is required'
      end
    end
  end

  describe 'self#confirm!' do
    before do
      @email = Email.new(:address => 'foo@bar.com')
      @email.send(:set_email_confirmation_token)
      Email.collection.insert({address: @email.address,
                               verified: false,
                               confirm_token: @email.confirm_token })
    end

    it 'uses a confirm token to verify an email' do
      Email.confirm!(@email.confirm_token)
      email = Email.collection.find({address: @email.address}).first
      email['verified'].should be_true
    end
  end
end
