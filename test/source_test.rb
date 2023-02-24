require_relative "test_helper"

class TestSource < Test::Unit::TestCase

  def test_source
    VCR.use_cassette("test_source") do
      res = Colrapi.source('9837')
      assert_equal(165, res.size)
    end
  end

  def test_source_not_current_only
    VCR.use_cassette("test_source_not_current_only") do
      res = Colrapi.source('9837', not_current_only: true)
      assert_equal(104, res.size)
    end
  end

  def test_source_id
    VCR.use_cassette("test_source_id") do
      res = Colrapi.source('9837', source_id: '1027')
      assert_equal('Scarabs', res['alias'])
    end
  end
end