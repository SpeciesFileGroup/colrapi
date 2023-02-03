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
end
