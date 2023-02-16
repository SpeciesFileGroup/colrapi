require_relative "test_helper"

class TestEditor < Test::Unit::TestCase
  def setup
    @dataset_id = '1021'
    @user_id = 182
    @user = ENV['CLB_USER']
    @password = ENV['CLB_PASS']
    @token = nil
    unless @user.nil? or @password.nil?
      @token = Colrapi.user_login(@user, @password)
    end
  end

  def test_editor
    VCR.use_cassette("test_editor") do
      res = Colrapi.editor(@dataset_id, 'a.b.c')
      assert_equal(401, res['code'])
    end
  end

  def test_editor_token
    unless @token.nil?
      VCR.use_cassette("test_editor_token") do
        res = Colrapi.editor(@dataset_id, @token)
        present = false
        res.each do |editor|
          if editor['username'] == @user
            present = true
          end
        end
        assert_true(present)
      end
    end
  end
end