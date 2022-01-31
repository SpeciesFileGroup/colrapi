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
  end

  def test_nameusage_offset_limit
    VCR.use_cassette("test_nameusage_offset_limit") do
      res = Colrapi.nameusage(q: @name, offset: 2, limit: 1)
      assert_equal(2, res['offset'])
      assert_equal(1, res['limit'])

    end
  end

  def test_nameusage_rank
    VCR.use_cassette("test_nameusage_rank") do
      res = Colrapi.nameusage(q: 'Atta', rank: 'genus')
      assert_equal('genus', res['result'][0]['classification'].last['rank'])
    end
  end

end
