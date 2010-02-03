begin
  require 'rubygems'
  require 'test/unit'
  require 'active_support'
  require 'shoulda'
  require File.dirname(__FILE__) + '/../lib/super_serialize'
rescue LoadError
  puts 'super_serialize tests rely on shoulda, and active_support'
end

Object.send :include, SuperSerialize

class User
  attr_accessor :id, :email, :serialized_data
  def self.serialize(*args) @serilarized = true; end
  def self.serialized_attributes() @serilarized ? { 'serialized_data' => Hash } : {}; end  
  def read_attribute(attribute) instance_variable_get("@#{attribute}"); end
  def initialize(params={})
    params.each { |key, value| self.send("#{key}=", value); }
    self
  end
end
