require_relative "test_helper"

class TestNameusage < Test::Unit::TestCase
  def setup
    @name = "Homo sapiens"
  end

  def test_nameusage
    VCR.use_cassette("nameusage_test") do
      res = Colrapi.nameusage(q: @name)
      assert_equal(true, res['result'].length > 0)
      assert_equal(Array, res['result'].class)
    end
    assert_equal(200, res[0].status)
  end

end
