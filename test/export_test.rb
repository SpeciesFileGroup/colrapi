require_relative "test_helper"

class TestExport < Test::Unit::TestCase

  def test_export
    VCR.use_cassette("test_export") do
      res = Colrapi.export('36223')
      assert_equal('x4', res[0]['id'])
    end
  end
end