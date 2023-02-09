require_relative "test_helper"

class TestImporter < Test::Unit::TestCase
  def setup
    @states = %w[waiting preparing downloading processing deleting inserting matching indexing analyzing archiving exporting unchanged finished canceled failed]
    @running_states = %w[waiting preparing downloading processing deleting inserting matching indexing analyzing archiving exporting]
  end
  def test_importer
    VCR.use_cassette("test_importer") do
      res = Colrapi.importer()
      res['result'].each do |d|
        assert_true(@states.include? d['state'])
      end
    end
  end

  def test_importer_id
    VCR.use_cassette("test_importer_id") do
      res = Colrapi.importer(dataset_id: '1148')
      assert_true(@states.include? res['state'])
    end
  end

  def test_importer_running_false
    VCR.use_cassette("test_importer_running_false") do
      res = Colrapi.importer(running: false)
      res['result'].each do |d|
        assert_false(@running_states.include? d['state'])
      end
    end
  end

  # will pass if importer is idle
  def test_importer_running_true
    VCR.use_cassette("test_importer_running_true") do
      res = Colrapi.importer(running: true)
      if res['total'] > 0
        res['result'].each do |d|
          assert_true(@running_states.include? d['state'])
        end
      else
        assert_equal(0, res['total'])
      end
    end
  end

  def test_importer_state_failed
    VCR.use_cassette("test_importer_state_failed") do
      res = Colrapi.importer(state: 'failed')
      res['result'].each do |d|
        assert_equal('failed', d['state'])
      end
    end
  end

end