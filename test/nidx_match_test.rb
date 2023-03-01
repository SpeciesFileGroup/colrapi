require_relative "test_helper"

class TestNidxMatch < Test::Unit::TestCase

  def test_nidx_match
    VCR.use_cassette("test_nidx_match") do
      res = Colrapi.nidx_match('Alces alces')
      assert_equal('species', res['name']['rank'])
    end
  end
end