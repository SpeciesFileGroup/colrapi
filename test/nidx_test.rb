require_relative "test_helper"

class TestNidx < Test::Unit::TestCase

  def test_nidx_id
    VCR.use_cassette("test_nidx_id") do
      res = Colrapi.nidx(1)
      assert_true(res.key? 'scientificName')
    end
  end

  def test_nidx_group
    VCR.use_cassette("test_nidx_group") do
      res = Colrapi.nidx(1, subresource: 'group')
      assert_equal(Array, res.class)
    end
  end
end