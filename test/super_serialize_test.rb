require File.dirname(__FILE__) + '/test_helper'

class SuperSerializeTest < Test::Unit::TestCase
  context 'default options' do
    setup do
      User.send(:super_serialize, :some_fake_column, :another_fake_column)
      @user = User.new(:id => 1, :email => 'Ary')
    end
    
    should 'define the methods' do
      assert_equal true, @user.respond_to?(:some_fake_column)
      assert_equal true, @user.respond_to?(:some_fake_column=)
      assert_equal true, @user.respond_to?(:another_fake_column)
      assert_equal true, @user.respond_to?(:another_fake_column=)
    end

    should 'initialize a user with fake columns' do
      user = User.new(:some_fake_column => 'some_value')
      assert_equal 'some_value', user.some_fake_column
    end
    
    should 'set a string' do
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = 'ary'
      assert_equal 'ary', @user.some_fake_column
    end

    should 'set an integer' do
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = 10
      assert_equal 10, @user.some_fake_column
    end

    should 'set a boolean' do
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = true
      assert_equal true, @user.some_fake_column
    end

    should 'set a time as string' do
      now = Time.now
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = now
      assert_equal now.to_s, @user.some_fake_column
    end

    should 'set a float as string' do
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = 10.5
      assert_equal '10.5', @user.some_fake_column
    end
  end
  
  context 'specifying accepts' do
    setup do
      User.send(:super_serialize, :some_fake_column, :accepts => String)
      @user = User.new(:id => 1, :email => 'Ary')
    end
    
    should 'define the methods' do
      assert_equal true, @user.respond_to?(:some_fake_column)
      assert_equal true, @user.respond_to?(:some_fake_column=)
    end
  
    should 'set a string' do
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = 'ary'
      assert_equal 'ary', @user.some_fake_column
    end
  
    should 'set an integer as string' do
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = 10
      assert_equal '10', @user.some_fake_column
    end
  
    should 'set a boolean as string' do
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = true
      assert_equal 'true', @user.some_fake_column
    end
  
    should 'set a time as string' do
      now = Time.now
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = now
      assert_equal now.to_s, @user.some_fake_column
    end
  
    should 'set a float as string' do
      assert_equal nil, @user.some_fake_column
      @user.some_fake_column = 10.5
      assert_equal '10.5', @user.some_fake_column
    end
  end
end
