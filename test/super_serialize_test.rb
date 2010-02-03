require File.dirname(__FILE__) + '/test_helper'

class SuperSerializeTest < Test::Unit::TestCase
  context SuperSerialize do
    setup do
      User.send(:super_serialize, :some_fake_column, String)
      User.send(:super_serialize, :another_fake_column, Boolean, :default => true)
      User.send(:super_serialize, :fake_integer_column, Integer, :default => 12)
      User.send(:super_serialize, :fake_float_column, Float, :default => 3.7)
      @user = User.new(:id => 1, :email => 'Ary')
    end

    should 'define the methods' do
      assert @user.respond_to?(:some_fake_column)
      assert @user.respond_to?(:some_fake_column=)
      assert @user.respond_to?(:another_fake_column)
      assert @user.respond_to?(:another_fake_column=)
      assert @user.respond_to?(:another_fake_column?)
      assert @user.respond_to?(:fake_integer_column)
      assert @user.respond_to?(:fake_integer_column=)
      assert @user.respond_to?(:fake_float_column)
      assert @user.respond_to?(:fake_float_column=)
    end

    should 'initialize a user with fake columns' do
      user = User.new(:some_fake_column => 'some_value', :another_fake_column => false, :fake_integer_column => 21, :fake_float_column => 5.9)
      assert_equal 'some_value', user.some_fake_column
      assert_equal false, user.another_fake_column
      assert_equal 21, user.fake_integer_column
      assert_equal 5.9, user.fake_float_column
    end

    should 'set defaults' do
      assert_equal true, User.new.another_fake_column
      assert_equal nil, User.new.some_fake_column
      assert_equal 12, User.new.fake_integer_column
      assert_equal 3.7, User.new.fake_float_column
    end

    should 'set everything as string for String fake column' do
      @user.some_fake_column = 'ary'
      assert_equal 'ary', @user.some_fake_column

      @user.some_fake_column = 10
      assert_equal '10', @user.some_fake_column

      @user.some_fake_column = true
      assert_equal 'true', @user.some_fake_column
    end

    should 'set everything as integer for Integer fake column' do
      @user.fake_integer_column = '10'
      assert_equal 10, @user.fake_integer_column

      @user.fake_integer_column = 10.9
      assert_equal 10, @user.fake_integer_column
    end

    should 'set everything as float for Float fake column' do
      @user.fake_float_column = '10.9'
      assert_equal 10.9, @user.fake_float_column

      @user.fake_float_column = 10
      assert_equal 10.0, @user.fake_float_column
    end

    should 'set everything as boolean for Boolean fake column' do
      @user.another_fake_column = 'ary'
      assert_equal false, @user.another_fake_column

      @user.another_fake_column = 10
      assert_equal false, @user.another_fake_column

      @user.another_fake_column = true
      assert_equal true, @user.another_fake_column

      @user.another_fake_column = 1
      assert_equal true, @user.another_fake_column

      @user.another_fake_column = 'true'
      assert_equal true, @user.another_fake_column
    end

    should 'create boolean helper for Boolean fake column' do
      assert @user.another_fake_column?
    end
  end
end
