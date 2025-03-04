require_relative "test_helper"

class TestNameusageSearch < Test::Unit::TestCase
  def setup
    @name = "Homo sapiens"
  end

  def test_nameusage_search
    VCR.use_cassette("nameusage_search_test") do
      res = Colrapi.nameusage_search(q: @name)
      assert_equal(true, res['result'].length > 0)
    end
  end

  def test_nameusage_search_offset
    VCR.use_cassette("test_nameusage_search_offset_limit") do
      res = Colrapi.nameusage_search(q: @name, offset: 2, limit: 1)
      assert_equal(2, res['offset'])
    end
  end

  def test_nameusage_search_limit
    VCR.use_cassette("test_nameusage_search_offset_limit") do
      res = Colrapi.nameusage_search(q: @name, offset: 2, limit: 1)
      assert_equal(1, res['limit'])
    end
  end

  def test_nameusage_search_name_rank
    VCR.use_cassette("test_nameusage_search_rank") do
      res = Colrapi.nameusage_search(q: 'Atta', rank: 'genus')
      assert_equal('genus', res['result'][0]['classification'].last['rank'])
    end
  end

  def test_nameusage_search_name_ranks
    VCR.use_cassette("test_nameusage_search_ranks") do
      res = Colrapi.nameusage_search(rank: ['genus', 'family'], limit: 50)
      res['result'].each do |nu|
        assert_true(%w[genus family].include? nu['usage']['name']['rank'])
      end
    end
  end

  def test_nameusage_search_min_max_ranks
    VCR.use_cassette("test_nameusage_search_min_max_ranks") do
      res = Colrapi.nameusage_search(q: 'Alces alces', dataset_id: '9837',
                                     min_rank: 'species', max_rank: 'genus', sort_by: 'TAXONOMIC')
      res['result'].each do |r|
        assert_includes(['genus', 'species'], r['usage']['name']['rank'])
      end
    end
  end

  def test_nameusage_search_environment
    VCR.use_cassette("test_nameusage_search_environment") do
      res = Colrapi.nameusage_search(dataset_id: '9837', environment: 'MARINE')
      res['result'].each do |res|
        assert_include(res['usage']['environments'], 'marine')
      end
    end
  end

  def test_nameusage_search_highest_taxon_id
    VCR.use_cassette("test_nameusage_search_highest_taxon_id") do
      res = Colrapi.nameusage_search(dataset_id: '9837', environment: 'MARINE', highest_taxon_id: 'RT')
      res['result'].each do |res|
        classification = {}
        res['classification'].each do |cl|
          classification[cl['rank']] = cl['name']
        end
        assert_equal(classification['phylum'], 'Arthropoda')
      end
    end
  end
end
