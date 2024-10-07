require_relative "test_helper"
require "date"

class TestSector < Test::Unit::TestCase
  def setup
    @dataset_id = '9837'
  end

  def test_sector
    VCR.use_cassette("test_sector") do
      res = Colrapi.sector(@dataset_id)
      assert_true(res['result'][0].key? 'target')
    end
  end

  def test_sector_offset
    VCR.use_cassette("test_sector_offset_limit") do
      res = Colrapi.sector(@dataset_id, offset: 11, limit: 5)
      assert_equal(11, res['offset'])
    end
  end

  def test_sector_limit
    VCR.use_cassette("test_sector_offset_limit") do
      res = Colrapi.sector(@dataset_id, offset: 11, limit: 5)
      assert_equal(5, res['limit'])
    end
  end

  def test_sector_id
    VCR.use_cassette("test_sector_id") do
      res = Colrapi.sector(@dataset_id, sector_id: 1756)
      assert_true(res.key? 'target')
    end
  end

  def test_sector_name
    VCR.use_cassette("test_sector_name") do
      res = Colrapi.sector(@dataset_id, name: 'Fabales')
      assert_equal(1759, res['result'][0]['id'])
    end
  end

  def test_sector_rank
    VCR.use_cassette("test_sector_rank") do
      res = Colrapi.sector(@dataset_id, rank: 'family')
      res['result'].each do |r|
        assert_equal('family', r['subject']['rank'])
      end
    end
  end

  def test_sector_modified_by
    VCR.use_cassette("test_sector_modified_by") do
      res = Colrapi.sector(@dataset_id, modified_by: 103)
      res['result'].each do |r|
        assert_equal(103, r['modifiedBy'])
      end
    end
  end

  def test_sector_broken
    VCR.use_cassette("test_sector_broken") do
      res = Colrapi.sector(@dataset_id, broken: true)
      res['result'].each do |r|
        assert_equal(true, r['subject']['broken'])
      end
    end
  end

  def test_sector_subject_dataset
    VCR.use_cassette("test_sector_subject_dataset") do
      res = Colrapi.sector(@dataset_id, subject_dataset_id: '1027')
      res['result'].each do |r|
        assert_equal(1027, r['subjectDatasetKey'])
      end
    end
  end

  def test_sector_last_synced
    VCR.use_cassette("test_sector_last_synced") do
      # merge sectors might not be synced, so filter by attach mode
      res = Colrapi.sector('3', last_synced_before: Date.new(2020,07,20), mode: 'attach')
      res['result'].each do |r|
        sync = Colrapi.sector_sync('3', sector_id: r['id'])
        assert_true(Date.parse(sync['started']) < Date.new(2020,07,20))
      end
    end
  end

  def test_sector_mode
    VCR.use_cassette("test_sector_mode") do
      res = Colrapi.sector('3', mode: 'attach')
      res['result'].each do |r|
        assert_equal('attach', r['mode'])
      end
    end
  end

  def test_sector_subject
    # TODO: unclear what the subject parameter does
  end

  def test_sector_min_size
    VCR.use_cassette("test_sector_min_size") do
      res = Colrapi.sector('3', min_size: 100000)
      res['result'].each do |r|
        sync = Colrapi.sector_sync('3', sector_id: r['id'])
        assert_true(sync['nameCount'] > 100000)
      end
    end
  end

  # most likely there will always be 0 sectors without data
  def test_sector_without_data
    VCR.use_cassette("test_sector_without_data") do
      without = Colrapi.sector('3', without_data: true)
      with = Colrapi.sector('3', without_data: false)
      assert_true(without['total'] < with['total'])
    end
  end
end
