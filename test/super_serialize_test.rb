require File.dirname(__FILE__) + '/test_helper'

class SuperSerializeTest < Test::Unit::TestCase
  context SuperSerialize do
    setup do
      User.send(:super_serialize, :some_fake_column, String)
      User.send(:super_serialize, :another_fake_column, Boolean, :default => true)
      @user = User.new(:id => 1, :email => 'Ary')
    end

    should 'define the methods' do
      assert @user.respond_to?(:some_fake_column)
      assert @user.respond_to?(:some_fake_column=)
      assert @user.respond_to?(:another_fake_column)
      assert @user.respond_to?(:another_fake_column=)
      assert @user.respond_to?(:another_fake_column?)
    end

    should 'initialize a user with fake columns' do
      user = User.new(:some_fake_column => 'some_value', :another_fake_column => false)
      assert_equal 'some_value', user.some_fake_column
      assert_equal false, user.another_fake_column
    end

    should 'set defaults' do
      assert_equal true, User.new.another_fake_column
      assert_equal nil, User.new.some_fake_column
    end

    should 'set everything as string for String fake column' do
      @user.some_fake_column = 'ary'
      assert_equal 'ary', @user.some_fake_column

      @user.some_fake_column = 10
      assert_equal '10', @user.some_fake_column

      @user.some_fake_column = true
      assert_equal 'true', @user.some_fake_column
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
