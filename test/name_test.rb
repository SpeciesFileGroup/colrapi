require_relative "test_helper"

class TestName < Test::Unit::TestCase
  def setup
    @dataset_id = "9837"
  end

  def test_name
    VCR.use_cassette("test_name") do
      res = Colrapi.name(@dataset_id)
      assert_equal(0, res['offset'])
      assert_equal(10, res['limit'])
      assert_equal(4716121, res['total'])
      assert_equal('00000fe0-d4e6-4a74-8c99-b4ad127e7e64', res['result'][9]['id'])
      assert_equal(103, res['result'][9]['createdBy'])
      assert_equal(103, res['result'][9]['modifiedBy'])
      assert_equal(676, res['result'][9]['sectorKey'])
      assert_equal('Pericycos philippinensis', res['result'][9]['scientificName'])
      assert_equal('Breuning, 1944', res['result'][9]['authorship'])
      assert_equal('species', res['result'][9]['rank'])
      assert_equal('Pericycos', res['result'][9]['genus'])
      assert_equal('philippinensis', res['result'][9]['specificEpithet'])
      assert_equal('Breuning', res['result'][9]['combinationAuthorship']['authors'][0])
      assert_equal('1944', res['result'][9]['combinationAuthorship']['year'])
      assert_equal('zoological', res['result'][9]['code'])
      assert_equal('source', res['result'][9]['origin'])
      assert_equal('scientific', res['result'][9]['type'])
      assert_equal('<i>Pericycos philippinensis</i> Breuning, 1944', res['result'][9]['labelHtml'])
      assert_equal(true, res['result'][9]['parsed'])
    end
  end

  def test_name_offset_limit
    VCR.use_cassette("test_name_offset_limit") do
      res = Colrapi.name(@dataset_id, offset: 13383, limit: 1)
      assert_equal(13383, res['offset'])
      assert_equal(1, res['limit'])
      assert_equal(4716121, res['total'])
      assert_equal('00b9bdb6-0434-44d2-becf-752f53f31cd4', res['result'][0]['id'])
      assert_equal(102, res['result'][0]['createdBy'])
      assert_equal(102, res['result'][0]['modifiedBy'])
      assert_equal(1386, res['result'][0]['sectorKey'])
      assert_equal('none', res['result'][0]['namesIndexType'])
      assert_equal('Silvius flavicinctus', res['result'][0]['scientificName'])
      assert_equal('Schuurmans Stekhoven, 1932', res['result'][0]['authorship'])
      assert_equal('species', res['result'][0]['rank'])
      assert_equal('Silvius', res['result'][0]['genus'])
      assert_equal('flavicinctus', res['result'][0]['specificEpithet'])
      assert_equal('Schuurmans Stekhoven', res['result'][0]['combinationAuthorship']['authors'][0])
      assert_equal('1932', res['result'][0]['combinationAuthorship']['year'])
      assert_equal('zoological', res['result'][0]['code'])
      assert_equal('7768714b-f51f-46c7-9abd-72fda11f89e2', res['result'][0]['publishedInId'])
      assert_equal('12', res['result'][0]['publishedInPage'])
      assert_equal('source', res['result'][0]['origin'])
      assert_equal('scientific', res['result'][0]['type'])
      assert_equal('<i>Silvius flavicinctus</i> Schuurmans Stekhoven, 1932', res['result'][0]['labelHtml'])
      assert_equal(true, res['result'][0]['parsed'])
    end
  end

  def test_name_id
    VCR.use_cassette("test_name_id") do
      res = Colrapi.name(@dataset_id, name_id: '00000fe0-d4e6-4a74-8c99-b4ad127e7e64')
      assert_equal('00000fe0-d4e6-4a74-8c99-b4ad127e7e64', res['id'])
      assert_equal(103, res['createdBy'])
      assert_equal(103, res['modifiedBy'])
      assert_equal(676, res['sectorKey'])
      assert_equal(5491940, res['namesIndexId'])
      assert_equal('exact', res['namesIndexType'])
      assert_equal('Pericycos philippinensis', res['scientificName'])
      assert_equal('Breuning, 1944', res['authorship'])
      assert_equal('species', res['rank'])
      assert_equal('Pericycos', res['genus'])
      assert_equal('philippinensis', res['specificEpithet'])
      assert_equal('Breuning', res['combinationAuthorship']['authors'][0])
      assert_equal('1944', res['combinationAuthorship']['year'])
      assert_equal('zoological', res['code'])
      assert_equal('source', res['origin'])
      assert_equal('scientific', res['type'])
      assert_equal('<i>Pericycos philippinensis</i> Breuning, 1944', res['labelHtml'])
      assert_equal(true, res['parsed'])
    end
  end

  def test_name_id_synonyms
    VCR.use_cassette("test_name_id_synonyms") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'synonyms')
      assert_equal(1, res.size)
      assert_equal('17b02a8a-6aa7-46c3-98e5-2ec3e714af32', res[0]['id'])
      assert_equal(102, res[0]['createdBy'])
      assert_equal(102, res[0]['modifiedBy'])
      assert_equal(1430, res[0]['sectorKey'])
      assert_equal('none', res[0]['namesIndexType'])
      assert_equal('Tettix pallitarsis', res[0]['scientificName'])
      assert_equal('Walker, 1871', res[0]['authorship'])
      assert_equal('species', res[0]['rank'])
      assert_equal('Tettix', res[0]['genus'])
      assert_equal('pallitarsis', res[0]['specificEpithet'])
      assert_equal('Walker', res[0]['combinationAuthorship']['authors'][0])
      assert_equal('1871', res[0]['combinationAuthorship']['year'])
      assert_equal('zoological', res[0]['code'])
      assert_equal('source', res[0]['origin'])
      assert_equal('scientific', res[0]['type'])
      assert_equal('<i>Tettix pallitarsis</i> Walker, 1871', res[0]['labelHtml'])
      assert_equal(true, res[0]['parsed'])
    end
  end

  def test_name_id_relations
    VCR.use_cassette("test_name_id_relations") do
      res = Colrapi.name(@dataset_id, name_id: 'a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', subresource: 'relations')
      assert_equal(1, res.size)
      assert_equal(270062, res[0]['id'])
      assert_equal(10, res[0]['createdBy'])
      assert_equal(10, res[0]['modifiedBy'])
      assert_equal('basionym', res[0]['type'])
      assert_equal('a9d3da6e-1e60-4011-a3a1-bfb24df61b3d', res[0]['nameId'])
      assert_equal('17b02a8a-6aa7-46c3-98e5-2ec3e714af32', res[0]['relatedNameId'])
      assert_equal(false, res[0]['rich'])
    end
  end

  # types do not seem to get synced into the CoL Annual Checklist so test might break if the data updates in Scarabs (1027)
  def test_name_id_types
    VCR.use_cassette("test_name_id_types") do
      res = Colrapi.name('1027', name_id: '18-.08-.26-.01-.003-.000-.041-.-', subresource: 'types')
      assert_equal(1, res.size)
      assert_equal('tmFM', res[0]['id'])
      assert_equal(10, res[0]['createdBy'])
      assert_equal(10, res[0]['modifiedBy'])
      assert_equal('holotype', res[0]['status'])
      assert_equal('18-.08-.26-.01-.003-.000-.041-.-', res[0]['nameId'])
      assert_equal('LINNE-005', res[0]['referenceId'])
      assert_equal('USA, Washington D.C., National Museum of Natural History, (formerly, United States National Museum)', res[0]['host'])
    end
  end

  # orphans are not synced into CoL so test might be broken with dataset 1141 updates
  # TODO: loads in random order, so unable to test data beyond offset, limit, total
  def test_name_orphans
    VCR.use_cassette("test_name_orphans") do
      res = Colrapi.name('1141', subresource: 'orphans', offset: 2, limit: 1, verbose: true)
      assert_equal(2, res['offset'])
      assert_equal(1, res['limit'])
      assert_equal(2, res['total'])
    end
  end
end
