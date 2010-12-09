module Validations
  module ClassMethods
    def validations
      @validations ||= Hash.new {|h,k| h[k] = {}}
    end

    def must_be_unique(attr, options = {})
      validations[:unique].merge!({"#{attr}".to_sym => options})
    end

    def must_be_formatted(attr, options = {})
      validations[:formatted].merge!({"#{attr}".to_sym => options})
    end

    def must_be_present(attr, options = {})
      validations[:present].merge!({"#{attr}".to_sym => options})
    end

    def must_be_number(attr, options = {:integer => false})
      validations[:number].merge!({"#{attr}".to_sym => options})
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
    if attr_value.nil?
      errors << "That #{attr} is required"
    end
  end

  def number?(attr, options)
    attr_value = self.send(attr)
    if options[:integer] == true
      errors << "That #{attr} is not an integer" unless attr_value.is_a?(Fixnum)
    else
      errors << "That #{attr} is not a number" unless attr_value.is_a?(Numeric)
    end
  end

end
