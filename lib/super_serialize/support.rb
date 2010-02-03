class Boolean
  BOOLEAN_MAPPING = {
    true => true, 'true' => true, 'TRUE' => true, 'True' => true, 't' => true, 'T' => true, '1' => true, 1 => true, 1.0 => true,
    false => false, 'false' => false, 'FALSE' => false, 'False' => false, 'f' => false, 'F' => false, '0' => false, 0 => false, 0.0 => false, nil => false
  }

  def self.to_super_serialize(value)
    if value.nil?
      nil
    else
      v = BOOLEAN_MAPPING[value]
      v = value.to_s.downcase == 'true' if v.nil?
      v
    end
  end
end

class String
  def self.to_super_serialize(value)
    value.nil? ? nil : value.to_s
  end
end

class Integer
  def self.to_super_serialize(value)
    value.nil? ? nil : value.to_i
  end
end

class Float
  def self.to_super_serialize(value)
    value.nil? ? nil : value.to_f
  end
end
