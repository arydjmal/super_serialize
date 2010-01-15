module SuperSerialize
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    COLUMN = 'serialized_data'
    CLASSES = [Boolean, Integer, String]

    def super_serialize(name, klass, options={})
      raise(ArgumentError, "super_serialize only supports #{CLASSES.to_sentence}") if !CLASSES.include?(klass)

      if !serialized_attributes[COLUMN]
        serialize COLUMN, Hash
        create_serialized_attribute_getter
      end

      create_accessors_for(name, klass, options)
      create_boolean_helper_for(name) if klass == Boolean
    end

    def create_serialized_attribute_getter
      class_eval %{
        def #{COLUMN}
          (value = read_attribute(:#{COLUMN})) && value.is_a?(Hash) ? value : self.#{COLUMN} = {}
        end
      }, __FILE__, __LINE__
    end

    def create_accessors_for(name, klass, options)
      class_eval %{
        def #{name}
          #{COLUMN}.key?(:#{name}) ? #{COLUMN}[:#{name}] : #{options[:default].inspect}
        end

        def #{name}=(value)
          self.#{COLUMN}[:#{name}] = #{klass}.to_super_serialize(value)
        end
      }, __FILE__, __LINE__
    end

    def create_boolean_helper_for(name)
      class_eval %{
        def #{name}?
          !!#{name}
        end
      }, __FILE__, __LINE__
    end
  end
end
