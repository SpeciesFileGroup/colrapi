require_relative "test_helper"

class TestPatch < Test::Unit::TestCase
  def setup
    @dataset_id = '3'
    @patch_id = '1027'
  end

  # expect unauthorized without token
  def test_patch
    VCR.use_cassette("test_patch") do
      res = Colrapi.patch(@dataset_id)
      assert_equal(401, res['code'])
    end
  end

  def test_patch_id
    VCR.use_cassette("test_patch_id") do
      res = Colrapi.patch(@dataset_id, patch_id: @patch_id)
      assert_equal('Scarabs', res['alias'])
    end
  end
end