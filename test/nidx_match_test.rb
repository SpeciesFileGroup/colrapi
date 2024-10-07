require_relative "test_helper"

class TestNidxMatch < Test::Unit::TestCase

  # TODO: might break if this issue is fixed: https://github.com/CatalogueOfLife/backend/issues/1362
  def test_nidx_match
    VCR.use_cassette("test_nidx_match") do
      res = Colrapi.nidx_match('Alces alces')
      assert_equal('unranked', res['name']['rank'])
    end
  end
end