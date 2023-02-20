require_relative "test_helper"

class TestVernacular < Test::Unit::TestCase
  def setup
    @col_ac22 = '9837'
  end

  def test_vernacular
    VCR.use_cassette("test_vernacular") do
      res = Colrapi.vernacular
      assert_true(res['result'][0].key? 'latin')
    end
  end

  def test_vernacular_offset
    VCR.use_cassette("test_vernacular_offset_limit") do
      res = Colrapi.vernacular(offset: 5, limit: 4)
      assert_equal(5, res['offset'])
    end
  end

  def test_vernacular_limit
    VCR.use_cassette("test_vernacular_offset_limit") do
      res = Colrapi.vernacular(offset: 5, limit: 4)
      assert_equal(4, res['limit'])
    end
  end

  def test_vernacular_dataset_id
    VCR.use_cassette("test_vernacular_dataset") do
      res = Colrapi.vernacular(dataset_id: @col_ac22)
      assert_equal(@col_ac22, res['result'][0]['datasetKey'].to_s)
    end
  end

  def test_vernacular_dataset_latin
    VCR.use_cassette("test_vernacular_dataset") do
      res = Colrapi.vernacular(dataset_id: @col_ac22)
      assert_true(res['result'][0].key? 'latin')
    end
  end

  def test_vernacular_dataset_offset
    VCR.use_cassette("test_vernacular_dataset_offset_limit") do
      res = Colrapi.vernacular(dataset_id: @col_ac22, offset: 8, limit: 6)
      assert_equal(8, res['offset'])
    end
  end

  def test_vernacular_dataset_limit
    VCR.use_cassette("test_vernacular_dataset_offset_limit") do
      res = Colrapi.vernacular(dataset_id: @col_ac22, offset: 8, limit: 6)
      assert_equal(6, res['limit'])
    end
  end

  def test_vernacular_dataset_lang
    VCR.use_cassette("test_vernacular_dataset_lang") do
      res = Colrapi.vernacular(dataset_id: @col_ac22, offset: 8, limit: 6)
      assert_equal(6, res['limit'])
    end
  end
end