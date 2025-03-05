require_relative "test_helper"

class TestPreview < Test::Unit::TestCase
  def setup
    @project_id = "3"
    @user_id = 182
    @token = nil
    @user = ENV['CLB_USER']
    @password = ENV['CLB_PASS']
    unless @user.nil? or @password.nil?
      @token = Colrapi.user_login(@user, @password)
    end
  end

  def test_preview_auth
    VCR.use_cassette("test_preview_auth") do
      if @token != nil
        res = Colrapi.preview(@project_id, @token)
        assert_equal('Catalogue of Life', res['title'])
      end
    end
  end
end