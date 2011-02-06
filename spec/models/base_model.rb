require File.dirname(__FILE__) + '/../spec_helper'

describe BaseModel do
  describe 'model attributes' do
    describe 'errors' do
      it 'has them' do
        model = BaseModel.new
        model.errors.should be_empty
      end

      it 'can be initialized' do
        model = BaseModel.new(:errors => ['doing it wrong'])
        model.errors.should include 'doing it wrong'
      end
    end

    describe 'validations' do
      it 'has them' do
        BaseModel.validations.should == {}
      end
    end
  end

  describe '#valid?' do
    let(:model) { BaseModel.new }

    context 'when no errors are present' do
      it 'is valid' do
        model.valid?.should be_true
      end
    end

    context 'when errors are present' do
      it 'is not valid' do
        model.errors << "Doing it wrong"
        model.valid?.should be_false
      end
    end
  end

  describe 'BaseModel#collection' do
    it 'returns a mongo collection' do
      BaseModel.collection.should be_a(Mongo::Collection)
    end
  end
end
