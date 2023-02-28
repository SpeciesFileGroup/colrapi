require_relative "test_helper"

class TestPreview < Test::Unit::TestCase
  def setup
    @project_id = "3"
  end

  def test_preview
    VCR.use_cassette("test_preview") do
      res = Colrapi.preview(@project_id)
      res2 = Colrapi.dataset(dataset_id: "#{@project_id}LRC")
      assert_equal(res['title'], res2['title'])
    end
  end

end