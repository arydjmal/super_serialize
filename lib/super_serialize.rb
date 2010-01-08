module SuperSerialize
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def super_serialize(*fake_columns)
      defaults = { :column => :serialized_data, :accepts => [Fixnum, TrueClass, FalseClass, String] }
      options  = defaults.merge(fake_columns.extract_options!)
      column   = options[:column].to_s
      accepted_classes = Array(options[:accepts])

      serialize column, Hash

      class_eval %{
        def #{column}
          (value = read_attribute(:#{column})) && value.is_a?(Hash) ? value : self.#{column} = {}
        end
        
        def stringify_if_necessary(value)
          #{accepted_classes.inspect}.include?(value.class) ? value : value.to_s
        end
      }, __FILE__, __LINE__
      
      fake_columns.each do |fake_column|        
        class_eval %{
          def #{fake_column}
            self.#{column}[:#{fake_column}]
          end

          def #{fake_column}=(value)
            self.#{column}[:#{fake_column}] = stringify_if_necessary(value)
          end
        }, __FILE__, __LINE__
      end
    end
  end
end
