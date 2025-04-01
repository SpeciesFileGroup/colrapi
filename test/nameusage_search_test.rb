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

  def test_nameusage_search_usage_id
    VCR.use_cassette("test_nameusage_search_usage_id") do
      res = Colrapi.nameusage_search(dataset_id: '9837', usage_id: 'C', limit: 100)
      res['result'].each do |res|
        assert_equal(res['usage']['name']['scientificName'], 'Chromista')
      end
    end
  end

  def test_nameusage_search_authorship
    VCR.use_cassette("test_nameusage_search_authorship") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', authorship: 'Walker', limit: 100)
      res['result'].each do |res|
        assert_includes(res['usage']['name']['authorship'], 'Walker')
      end
    end
  end

  def test_nameusage_search_authorship_year
    VCR.use_cassette("test_nameusage_search_authorship_year") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', authorship_year: ['2001'], limit: 100)
      res['result'].each do |res|
        assert_includes(res['usage']['name']['authorship'], '2001')
      end
    end
  end

  def test_nameusage_search_extinct
    VCR.use_cassette("test_nameusage_search_extinct") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', extinct: 1, limit: 100)
      res['result'].each do |res|
        assert_true(res['usage']['extinct'])
      end
    end
  end

  def test_nameusage_search_field
    VCR.use_cassette("test_nameusage_search_field") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', field: 'uninomial', limit: 100)
      res['result'].each do |res|
        assert_true(res['usage']['name']['uninomial'] != "")
      end
    end
  end

  def test_nameusage_search_name_type
    VCR.use_cassette("test_nameusage_search_name_type") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', name_type: 'otu', limit: 100, offset: 100)
      res['result'].each do |res|
        assert_includes(res['usage']['name']['scientificName'], "BOLD:")
      end
    end
  end

  def test_nameusage_search_nomenclatural_code
    VCR.use_cassette("test_nameusage_search_nomenclatural_code") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', nomenclatural_code: 'botanical', limit: 100)
      res['result'].each do |res|
        assert_equal(res['usage']['name']['code'], 'botanical')
      end
    end
  end

  def test_nameusage_search_nomenclatural_status
    VCR.use_cassette("test_nameusage_search_nomenclatural_status") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', nomenclatural_status: 'manuscript', limit: 100)
      res['result'].each do |res|
        assert_equal(res['usage']['name']['nomStatus'], 'manuscript')
      end
    end
  end

  def test_nameusage_search_origin
    VCR.use_cassette("test_nameusage_search_origin") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', origin: 'user', limit: 100)
      res['result'].each do |res|
        assert_equal(res['usage']['name']['origin'], 'user')
      end
    end
  end

  def test_nameusage_search_secondary_source
    VCR.use_cassette("test_nameusage_search_secondary_source") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', secondary_source: 'holotype', limit: 100)
      res['result'].each do |res|
        assert_includes(res['secondarySourceGroups'], 'holotype')
      end
    end
  end

  def test_nameusage_search_sector_dataset_id
    VCR.use_cassette("test_nameusage_search_sector_dataset_id") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', sector_dataset_id: '37384', limit: 100, offset: 100)
      res['result'].each do |res|
        assert_equal(res['sectorDatasetKey'], 37384)
      end
    end
  end

  def test_nameusage_search_sector_mode
    VCR.use_cassette("test_nameusage_search_sector_mode") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', sector_mode: 'merge', limit: 100)
      res['result'].each do |res|
        assert_equal(res['usage']['merged'], true)
      end
    end
  end

  def test_nameusage_search_status
    VCR.use_cassette("test_nameusage_search_status") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', status: 'misapplied', limit: 100)
      res['result'].each do |res|
        assert_equal(res['usage']['status'], 'misapplied')
      end
    end
  end

  def test_nameusage_search_taxonomic_group
    VCR.use_cassette("test_nameusage_search_taxonomic_group") do
      res = Colrapi.nameusage_search(dataset_id: '3LXR', taxonomic_group: 'eukaryotes', limit: 100)
      res['result'].each do |res|
        assert_equal(res['group'], 'eukaryotes')
      end
    end
  end


end
