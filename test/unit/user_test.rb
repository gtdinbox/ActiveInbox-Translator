require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "User#has_password? " do
    user = user_fixture
    user.save

    assert user.has_password?('blabla')
    assert user.has_password?('wrong') === false
  end
  test "User#validate_password_confirmation " do
    user = user_fixture(:password_confirmation => 'wrong-value')
    assert user.save === false, "Should require password confirmation"
  end
  test "User::authenticate " do
    2.times do |n|
      user_fixture(:email => "user#{n}@mailinator.com").save
    end
    assert User.authenticate("user1@mailinator.com", 'blabla'), "Should authenticate user"
    assert User.authenticate("user1@mailinator.com", 'blablabzzz') === false, "Should not authenticate user"
  end


  private
  def user_fixture(attr_override={})
    fixture = {
      :password => 'blabla',
      :password_confirmation => 'blabla',
      :email => 'user@mailinator.net'
    }.merge(attr_override)

    User.new(fixture)
  end

end
