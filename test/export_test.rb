require_relative "test_helper"

class TestExport < Test::Unit::TestCase

  def test_export
    VCR.use_cassette("test_export") do
      res = Colrapi.export('36223')
      assert_equal('FCDBA0E8.psocodea.order', res[0]['id'])
    end
  end
end