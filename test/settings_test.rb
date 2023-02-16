require_relative "test_helper"

class TestSettings < Test::Unit::TestCase

  def test_settings
    VCR.use_cassette("test_settings") do
      res = Colrapi.settings('1021')
      assert_equal('coldp', res['data format'])
    end
  end
end