require_relative "test_helper"

class TestDuplidate < Test::Unit::TestCase
  def setup
    @dataset_id = "9837"
  end

  def test_duplicate
    VCR.use_cassette("test_duplicate") do
      res = Colrapi.duplicate(@dataset_id)
      res['result'].each do |d|
        assert_equal(d['usages'][0]['usage']['name']['scientificName'], d['usages'][1]['usage']['name']['scientificName'])
      end
    end
  end
end