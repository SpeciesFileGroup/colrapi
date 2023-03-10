require_relative "test_helper"

class TestPreview < Test::Unit::TestCase
  def setup
    @project_id = "3"
  end

  # only tests that it's metadata for a CoL release and not that it's the latest preview release
  def test_preview
    VCR.use_cassette("test_preview") do
      res = Colrapi.preview(@project_id)
      assert_equal('Catalogue of Life Checklist', res['title'])
    end
  end
end