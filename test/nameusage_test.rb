require_relative "test_helper"

class TestNameusage < Test::Unit::TestCase
  def setup
    @dataset_id = "9837"
  end

  def test_nameusage
    VCR.use_cassette("test_nameusage") do
      res = Colrapi.nameusage(@dataset_id)
      assert_equal('32', res['result'][0]['id'])
    end
  end

  def test_nameusage_id_related
    VCR.use_cassette("test_nameusage_id_related") do
      res = Colrapi.nameusage(@dataset_id, nameusage_id: '32', subresource: 'related')
      assert_true(res.size > 0)
    end
  end

  def test_nameusage_id_source
    VCR.use_cassette("test_nameusage_id_source") do
      res = Colrapi.nameusage(@dataset_id, nameusage_id: '32', subresource: 'source')
      assert_equal('956103', res['sourceId'])
    end
  end

  def test_nameusage_id
    VCR.use_cassette("test_nameusage_id") do
      res = Colrapi.nameusage(@dataset_id, nameusage_id: '32')
      assert_equal('Caldiserica Mori et al., 2009', res['label'])
    end
  end

  def test_nameusage_offset
    VCR.use_cassette("test_nameusage_offset_limit") do
      res = Colrapi.nameusage(@dataset_id, offset: 48, limit: 3)
      assert_equal(48, res['offset'])
    end
  end

  def test_nameusage_limit
    VCR.use_cassette("test_nameusage_offset_limit") do
      res = Colrapi.nameusage(@dataset_id, offset: 48, limit: 3)
      assert_equal(3, res['limit'])
    end
  end

  def test_nameusage_total
    VCR.use_cassette("test_nameusage_offset_limit") do
      res = Colrapi.nameusage(@dataset_id, offset: 48, limit: 3)
      assert_equal(4716121, res['total'])
    end
  end

  def test_nameusage_offset_limit_name
    VCR.use_cassette("test_nameusage_offset_limit") do
      res = Colrapi.nameusage(@dataset_id, offset: 48, limit: 3)
      assert_equal('Cryptorrhynchus biguttatus', res['result'][1]['name']['scientificName'])
    end
  end

  def test_nameusage_q
    VCR.use_cassette("test_nameusage_q") do
      res = Colrapi.nameusage(@dataset_id, q: 'Isoptera')
      assert_equal('Scheff. ex Burck', res['result'][0]['name']['authorship'])
    end
  end

  def test_nameusage_q_rank
    VCR.use_cassette("test_nameusage_q_rank") do
      res = Colrapi.nameusage(@dataset_id, q: 'Isoptera', rank: 'infraorder')
      assert_equal('Brulle, 1832', res['result'][0]['name']['authorship'])
    end
  end

  # periodically fails when elastic search and the database get out of sync
  # def test_nameusage_nidx_id
  #   VCR.use_cassette("test_nameusage_nidx_id") do
  #     res = Colrapi.nameusage(@dataset_id, nidx_id: 2403703)
  #     assert_equal('Cryptoripersia corpulenta', res['result'][0]['name']['scientificName'])
  #   end
  # end

end