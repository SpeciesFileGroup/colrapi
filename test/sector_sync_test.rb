require_relative "test_helper"

class TestSectorSync < Test::Unit::TestCase
  def setup
    @col_ac22 = '9837'
    @col_draft = '3'
  end

  def test_sector_sync
    VCR.use_cassette("test_sector_sync") do
      res = Colrapi.sector_sync(@col_draft)
      res['result'].each do |r|
        assert_equal('SectorSync', r['job'])
      end
    end
  end

  def test_sector_sync_id
    VCR.use_cassette("test_sector_sync_id") do
      res = Colrapi.sector_sync(@col_draft)
      sector = Colrapi.sector_sync(@col_draft, sector_id: res['result'][0]['sectorKey'])
      assert_equal(res['result'][0]['sectorKey'], sector['sectorKey'])
    end
  end

  def test_sector_sync_id_names
    VCR.use_cassette("test_sector_sync_id_names") do
      res = Colrapi.sector_sync(@col_draft)
      sector_id = res['result'][0]['sectorKey']
      attempt = res['result'][0]['attempt']
      names = Colrapi.sector_sync(@col_draft, sector_id: sector_id, attempt: attempt, subresource: 'names')
      i = 0
      names.split(/\n/).each do |name|
        i += 1
        parsed_name = Colrapi.parser_name(name)
        assert_true(parsed_name['parsed'])
        break if i > 10
      end
    end
  end

  def test_sector_sync_offset
    VCR.use_cassette("test_sector_sync_offset_limit") do
      res = Colrapi.sector_sync(@col_draft, offset: 3, limit: 7)
      assert_equal(3, res['offset'])
    end
  end

  def test_sector_sync_limit
    VCR.use_cassette("test_sector_sync_offset_limit") do
      res = Colrapi.sector_sync(@col_draft, offset: 3, limit: 7)
      assert_equal(7, res['limit'])
    end
  end

  def test_sector_sync_state
    VCR.use_cassette("test_sector_sync_state") do
      res = Colrapi.sector_sync(@col_draft, state: 'finished')
      res['result'].each do |r|
        assert_equal('finished', r['state'])
      end
    end
  end

  def test_sector_sync_running
    VCR.use_cassette("test_sector_sync_running") do
      res = Colrapi.sector_sync(@col_draft, running: false)
      res['result'].each do |r|
        assert_include(['unchanged', 'finished', 'canceled', 'failed'], r['state'])
      end
    end
  end
end