require_relative "test_helper"

class TestUser < Test::Unit::TestCase
  def setup
    @user_id = 182
    @user = ENV['USER']
    @password = ENV['PASSWORD']
    @token = Colrapi.user_login(@user, @password)
  end

  #   expects a 401 error without user authentication
  def test_user
    VCR.use_cassette("test_user") do
      res = Colrapi.user()
      assert_equal(401, res['code'])
    end
  end

  def test_user_token
    VCR.use_cassette("test_user_token") do
      res = Colrapi.user(q: @user, token: @token)
      assert_equal(@user, res['result'][0]['username'])
    end
  end

  def test_user_182
    VCR.use_cassette("test_user_182") do
      res = Colrapi.user(user_id: @user_id)
      assert_equal(@user, res['username'])
    end
  end

  def test_user_login
    VCR.use_cassette("test_user_login") do
      res = Colrapi.user_login(@user, @password)
      assert_true(/^[a-zA-Z0-9\-_]{20}\.[a-zA-Z0-9\-_]{156}\.[a-zA-Z0-9\-_]{64}$/.match? res)
    end
  end

  def test_user_me
    VCR.use_cassette("test_user_me") do
      res = Colrapi.user_me(@token)
      assert_equal(@user, res['username'])
    end
  end
end