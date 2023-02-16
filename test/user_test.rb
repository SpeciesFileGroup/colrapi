require_relative "test_helper"

class TestUser < Test::Unit::TestCase
  def setup
    @user_id = 182
    @token = nil
    @user = ENV['CLB_USER']
    @password = ENV['CLB_PASS']
    unless @user.nil? or @password.nil?
      @token = Colrapi.user_login(@user, @password)
    end
  end

  #   expects a 401 error without user authentication
  def test_user
    VCR.use_cassette("test_user") do
      res = Colrapi.user
      assert_equal(401, res['code'])
    end
  end

  def test_user_token
    unless @token.nil?
      VCR.use_cassette("test_user_token") do
        res = Colrapi.user(q: @user, token: @token)
        assert_equal(@user, res['result'][0]['username'])
      end
    end
  end

  def test_user_182
    VCR.use_cassette("test_user_182") do
      res = Colrapi.user(user_id: @user_id)
      assert_equal('speciesfilegroup', res['username'])
    end
  end

  def test_user_login
    unless @user.nil? or @password.nil?
      VCR.use_cassette("test_user_login") do
        res = Colrapi.user_login(@user, @password)
        assert_true(/^[a-zA-Z0-9\-_]{20}\.[a-zA-Z0-9\-_]{156}\.[a-zA-Z0-9\-_]{64}$/.match? res)
      end
    end
  end

  def test_user_me
    unless @token.nil?
      VCR.use_cassette("test_user_me") do
        res = Colrapi.user_me(@token)
        assert_equal(@user, res['username'])
      end
    end
  end
end