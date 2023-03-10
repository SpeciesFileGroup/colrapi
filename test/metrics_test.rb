require_relative "test_helper"

class TestMetrics < Test::Unit::TestCase

  def test_metrics
    VCR.use_cassette("test_metrics") do
      res = Colrapi.metrics('9837')
      assert_equal(2485345, res['taxonCount'])
    end
  end

  def test_metrics_unchanged
    VCR.use_cassette("test_metrics_unchanged") do
      res = Colrapi.metrics('49590')
      assert_equal(13, res['taxonCount'])
    end
  end

  def test_metrics_failed_import
    VCR.use_cassette("test_metrics_failed_import") do
      failed_queue = Colrapi.importer(state: 'failed')
      failed_queue['result'].each do |r|
        dataset_id = r['datasetKey']
        importer = Colrapi.importer(dataset_id: dataset_id)
        unless importer['state'] == 'failed'
          next
        end
        res = Colrapi.metrics(dataset_id)
        assert_equal('Dataset has not finished importing or failed to import', res['message'])
      end
    end
  end
end