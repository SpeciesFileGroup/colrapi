require_relative "test_helper"

class TestSynonym < Test::Unit::TestCase
  def setup
    @synonym_id = '32HWN'
    @dataset_id = "9837"
  end

  def test_synonym_scientific_name
    VCR.use_cassette("test_synonym") do
      res = Colrapi.synonym(@dataset_id)
      assert_equal('Craciformes', res['result'][0]['name']['scientificName'])
    end
  end

  def test_synonym_accepted_name
    VCR.use_cassette("test_synonym") do
      res = Colrapi.synonym(@dataset_id)
      assert_equal('Galliformes', res['result'][0]['accepted']['name']['scientificName'])
    end
  end

  def test_synonym_offset
    VCR.use_cassette("test_synonym_offset_limit") do
      res = Colrapi.synonym(@dataset_id, offset: 3893, limit: 4)
      assert_equal(3893, res['offset'])
    end
  end

  def test_synonym_limit
    VCR.use_cassette("test_synonym_offset_limit") do
      res = Colrapi.synonym(@dataset_id, offset: 3893, limit: 4)
      assert_equal(4, res['limit'])
    end
  end

  def test_synonym_offset_total
    VCR.use_cassette("test_synonym_offset_limit") do
      res = Colrapi.synonym(@dataset_id, offset: 3893, limit: 4)
      assert_equal(2230776, res['total'])
    end
  end

  def test_synonym_by_id_scientific_name
    VCR.use_cassette("test_synonym_by_id") do
      res = Colrapi.synonym(@dataset_id, synonym_id: @synonym_id)
      assert_equal('Curculio pallidus', res['name']['scientificName'])
    end
  end

  def test_synonym_by_id_accepted_name
    VCR.use_cassette("test_synonym_by_id") do
      res = Colrapi.synonym(@dataset_id, synonym_id: @synonym_id)
      assert_equal('Phyllobius (Plagius) pallidus', res['accepted']['name']['scientificName'])
    end
  end

  def test_synonym_by_id_source_id
    VCR.use_cassette("test_synonym_by_id_source") do
      res = Colrapi.synonym(@dataset_id, synonym_id: @synonym_id, subresource: 'source')
      assert_equal('634871-737261-99ca280a605dff7cb4c685d560b440a5', res['sourceId'])
    end
  end

  def test_synonym_by_id_source_id_dataset
    VCR.use_cassette("test_synonym_by_id_source") do
      res = Colrapi.synonym(@dataset_id, synonym_id: @synonym_id, subresource: 'source')
      assert_equal(1166, res['sourceDatasetKey'])
    end
  end
end
