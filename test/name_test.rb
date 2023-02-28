require_relative "test_helper"

class TestName < Test::Unit::TestCase
  def setup
    @dataset_id = "9837"
  end

  def test_name_id
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('00000fe0-d4e6-4a74-8c99-b4ad127e7e64', res['result'][9]['id'])
    end
  end

  def test_name_scientific
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('Pericycos philippinensis', res['result'][9]['scientificName'])
    end
  end

  def test_name_authorship
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('Breuning, 1944', res['result'][9]['authorship'])
    end
  end

  def test_name_rank
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('species', res['result'][9]['rank'])
    end
  end

  def test_name_genus
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('Pericycos', res['result'][9]['genus'])
    end
  end

  def test_name_specific_epithet
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('philippinensis', res['result'][9]['specificEpithet'])
    end
  end

  def test_name_authors0
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('Breuning', res['result'][9]['combinationAuthorship']['authors'][0])
    end
  end

  def test_name_year
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('1944', res['result'][9]['combinationAuthorship']['year'])
    end
  end

  def test_name_code
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('zoological', res['result'][9]['code'])
    end
  end

  def test_name_origin
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal('source', res['result'][9]['origin'])
    end
  end

  def test_name_offset
    VCR.use_cassette("test_name_offset_limit") do
      res = Colrapi.name(@dataset_id, offset: 13383, limit: 1)
      assert_equal(13383, res['offset'])
    end
  end

  def test_name_limit
    VCR.use_cassette("test_name_offset_limit") do
      res = Colrapi.name(@dataset_id, offset: 13383, limit: 1)
      assert_equal(1, res['limit'])
    end
  end

  def test_name_total
    VCR.use_cassette("test_name_offset_limit") do
      res = Colrapi.name(@dataset_id, offset: 13383, limit: 1)
      assert_equal(4716121, res['total'])
    end
  end

  def test_name_by_id
    VCR.use_cassette("test_name_id") do
      res = Colrapi.name(@dataset_id, name_id: '00000fe0-d4e6-4a74-8c99-b4ad127e7e64')
      assert_equal('00000fe0-d4e6-4a74-8c99-b4ad127e7e64', res['id'])
    end
  end

  def test_name_by_id_scientific_name
    VCR.use_cassette("test_name_id") do
      res = Colrapi.name(@dataset_id, name_id: '00000fe0-d4e6-4a74-8c99-b4ad127e7e64')
      assert_equal('Pericycos philippinensis', res['scientificName'])
    end
  end

  def test_name_by_id_authorship
    VCR.use_cassette("test_name_id") do
      res = Colrapi.name(@dataset_id, name_id: '00000fe0-d4e6-4a74-8c99-b4ad127e7e64')
      assert_equal('Breuning, 1944', res['authorship'])
    end
  end

  def test_name_by_id_rank
    VCR.use_cassette("test_name_id") do
      res = Colrapi.name(@dataset_id, name_id: '00000fe0-d4e6-4a74-8c99-b4ad127e7e64')
      assert_equal('species', res['rank'])
    end
  end

  def test_name_by_id_code
    VCR.use_cassette("test_name_id") do
      res = Colrapi.name(@dataset_id, name_id: '00000fe0-d4e6-4a74-8c99-b4ad127e7e64')
      assert_equal('zoological', res['code'])
    end
  end

  def test_name_id_synonyms_id
    VCR.use_cassette("test_name_id_synonyms") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'synonyms')
      assert_equal('17b02a8a-6aa7-46c3-98e5-2ec3e714af32', res[0]['id'])
    end
  end

  def test_name_id_synonyms_scientific_name
    VCR.use_cassette("test_name_id_synonyms") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'synonyms')
      assert_equal('Tettix pallitarsis', res[0]['scientificName'])
    end
  end

  def test_name_id_synonyms_authorship
    VCR.use_cassette("test_name_id_synonyms") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'synonyms')
      assert_equal('Walker, 1871', res[0]['authorship'])
    end
  end

  def test_name_id_synonyms_rank
    VCR.use_cassette("test_name_id_synonyms") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'synonyms')
      assert_equal('species', res[0]['rank'])
    end
  end

  def test_name_id_synonyms_code
    VCR.use_cassette("test_name_id_synonyms") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'synonyms')
      assert_equal('zoological', res[0]['code'])
    end
  end

  def test_name_id_relations_type
    VCR.use_cassette("test_name_id_relations") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'relations')
      assert_equal('basionym', res[0]['type'])
    end
  end

  def test_name_id_relations_name_id
    VCR.use_cassette("test_name_id_relations") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'relations')
      assert_equal('a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', res[0]['nameId'])
    end
  end

  def test_name_id_relations_related_name_id
    VCR.use_cassette("test_name_id_relations") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'relations')
      assert_equal('17b02a8a-6aa7-46c3-98e5-2ec3e714af32', res[0]['relatedNameId'])
    end
  end

  # types do not seem to get synced into the CoL Annual Checklist so test might break if the data updates in Scarabs (1027)
  def test_name_id_types_type
    VCR.use_cassette("test_name_id_types") do
      res = Colrapi.name('1027', name_id: '18-.08-.26-.01-.003-.000-.041-.-', subresource: 'types')
      assert_equal('holotype', res[0]['status'])
    end
  end

  def test_name_id_types_ref_id
    VCR.use_cassette("test_name_id_types") do
      res = Colrapi.name('1027', name_id: '18-.08-.26-.01-.003-.000-.041-.-', subresource: 'types')
      assert_equal('LINNE-005', res[0]['referenceId'])
    end
  end

  def test_name_id_types_host
    VCR.use_cassette("test_name_id_types") do
      res = Colrapi.name('1027', name_id: '18-.08-.26-.01-.003-.000-.041-.-', subresource: 'types')
      assert_equal('USA, Washington D.C., National Museum of Natural History, (formerly, United States National Museum)', res[0]['host'])
    end
  end

  # orphans are not synced into CoL so test might be broken with dataset 1141 updates
  # def test_name_orphans_rank
  #   VCR.use_cassette("test_name_orphans") do
  #     res = Colrapi.name('1141', subresource: 'orphans', offset: 0, limit: 1)
  #     assert_true(!!res['result'][0]['rank'].match(/^[a-z]+$/))
  #   end
  # end
  #
  # def test_name_orphans_genus
  #   VCR.use_cassette("test_name_orphans") do
  #     res = Colrapi.name('1141', subresource: 'orphans', offset: 0, limit: 1)
  #     assert_true(!!res['result'][0]['genus'].match(/^[A-Z][a-z]+$/))
  #   end
  # end
  #
  # def test_name_orphans_specific_epithet
  #   VCR.use_cassette("test_name_orphans") do
  #     res = Colrapi.name('1141', subresource: 'orphans', offset: 0, limit: 1)
  #     assert_true(!!res['result'][0]['specificEpithet'].match(/^[a-z]+$/))
  #   end
  # end
end
