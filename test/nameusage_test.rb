require_relative "test_helper"

class TestNameusage < Test::Unit::TestCase
  def setup
    @name = "Homo sapiens"
  end

  def test_nameusage_search
    VCR.use_cassette("nameusage_search_test") do
      res = Colrapi.nameusage_search(q: @name)
      assert_equal(true, res['result'].length > 0)
      assert_equal(Array, res['result'].class)
    end
  end

  def test_nameusage_search_offset_limit
    VCR.use_cassette("test_nameusage_search_offset_limit") do
      res = Colrapi.nameusage_search(q: @name, offset: 2, limit: 1)
      assert_equal(2, res['offset'])
      assert_equal(1, res['limit'])

    end
  end

  def test_nameusage_search_rank
    VCR.use_cassette("test_nameusage_search_rank") do
      res = Colrapi.nameusage_search(q: 'Atta', rank: 'genus')
      assert_equal('genus', res['result'][0]['classification'].last['rank'])
    end
  end

  def test_nameusage_search_min_max_ranks
    VCR.use_cassette("test_nameusage_search_min_max_ranks") do
      res = Colrapi.nameusage_search(q: 'Alces alces', dataset_id: '9837',
                                     min_rank: 'species', max_rank: 'genus', sort_by: 'TAXONOMIC')
      assert_equal('genus', res['result'][0]['usage']['name']['rank'])
      assert_equal(44, res['total'])
      assert_equal('species', res['result'][9]['usage']['name']['rank'])
    end
  end

end
