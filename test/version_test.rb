require_relative "test_helper"

class TestVersion < Test::Unit::TestCase

  def test_version
    VCR.use_cassette("test_version") do
      res = Colrapi.version
      assert_true(/^[0-9a-f]{7} [0-9]{4}-[0-9]{2}-[0-9]{2}$/.match? res)
    end
  end
end