module Validations
  module ClassMethods
    def validations
      @validations ||= Hash.new {|h,k| h[k] = {}}
    end

    def must_be_unique(attr, options = {})
      validations[:unique] = { "#{attr}".to_sym => options }
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def valid?
    validate!
    errors.empty?
  end

  def validate!
    self.class.validations.each do |validation, options|
      options.each do |attr,options|
        self.send("#{validation}?".to_sym, attr, options)
      end
    end
  end

  def unique?(attr, options)
    attribute_value = self.send(attr)
    doc = self.class.collection.find_one({attr => attribute_value})
    self.errors << "That #{attr} has already been taken" unless doc.nil?
  end

end
