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
      dataset_id = failed_queue['result'][0]['datasetKey']
      res = Colrapi.metrics(dataset_id)
      assert_equal('Dataset has not finished importing or failed to import', res['message'])
    end
  end
end