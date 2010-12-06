require File.dirname(__FILE__) + '/../spec_helper'

describe Email do
  before { Email.collection.drop() }
  after { Email.collection.drop() }

  context 'validations' do
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
end


