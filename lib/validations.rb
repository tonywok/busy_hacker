module Validations
  module ClassMethods
    def validations
      @validations ||= Hash.new {|h,k| h[k] = {}}
    end

    def must_be_unique(attr, options = {})
      validations[:unique] = { "#{attr}".to_sym => options }
    end

    def must_be_formatted(attr, options = {})
      validations[:formatted] = { "#{attr}".to_sym => options }
    end

    def must_be_present(attr, options = {})
      validations[:present] = { "#{attr}".to_sym => options }
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def valid?
    validate
    errors.empty?
  end

  def validate
    # find a place to throw error, perhaps validate!
    self.class.validations.each do |validation, options|
      options.each do |attr,options|
        self.send("#{validation}?".to_sym, attr, options)
      end
    end
  end

  def unique?(attr, options)
    attr_value = self.send(attr)
    doc = self.class.collection.find_one({attr => attr_value})
    errors << "That #{attr} has already been taken" unless doc.nil?
  end

  def formatted?(attr, options)
    attr_value = self.send(attr)
    unless attr_value =~ options[:with]
      errors << "That #{attr} is formatted incorrectly"
    end
  end

  def present?(attr, options)
    attr_value = self.send(attr)
    if attr_value.nil? || attr_value.empty?
      errors << "Email #{attr} is required"
    end
  end

end
