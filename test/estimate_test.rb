require_relative "test_helper"

class TestEstimate < Test::Unit::TestCase
  def setup
    @dataset_id = "9837"
  end

  def test_estimate
    VCR.use_cassette("test_estimate") do
      res = Colrapi.estimate(@dataset_id)
      assert_true(/^[0-9]+$/.match? res['result'][0]['estimate'].to_s)
    end
  end

  def test_estimate_offset
    VCR.use_cassette("test_estimate_offset_limit") do
      res = Colrapi.estimate(@dataset_id, offset: 7, limit: 3)
      assert_equal(7, res['offset'])
    end
  end

  def test_estimate_limit
    VCR.use_cassette("test_estimate_offset_limit") do
      res = Colrapi.estimate(@dataset_id, offset: 7, limit: 3)
      assert_equal(3, res['limit'])
    end
  end

  def test_estimate_id
    VCR.use_cassette("test_estimate_id") do
      res = Colrapi.estimate(@dataset_id, estimate_id: 68)
      assert_equal(1525728, res['estimate'])
    end
  end

  def test_estimate_name
    VCR.use_cassette("test_estimate_name") do
      res = Colrapi.estimate(@dataset_id, name: 'Animalia')
      res['result'].each do |e|
        assert_equal('Animalia', e['target']['name'])
      end
    end
  end

  def test_estimate_rank
    VCR.use_cassette("test_estimate_rank") do
      res = Colrapi.estimate(@dataset_id, rank: 'family')
      res['result'].each do |e|
        assert_equal('family', e['target']['rank'])
      end
    end
  end

  def test_estimate_modified_by
    VCR.use_cassette("test_estimate_modified_by") do
      res = Colrapi.estimate(@dataset_id, modified_by: 102)
      res['result'].each do |e|
        assert_equal(102, e['modifiedBy'])
      end
    end
  end

  def test_estimate_broken_true
    VCR.use_cassette("test_estimate_broken_true") do
      res = Colrapi.estimate(@dataset_id, broken: true)
      res['result'].each do |e|
        assert_true(e['target']['broken'])
      end
    end
  end

  # TODO: backend bug not filtering broken=false
  # def test_estimate_broken_false
  #   VCR.use_cassette("test_estimate_broken_false") do
  #     res = Colrapi.estimate(@dataset_id, broken: false)
  #     res['result'].each do |e|
  #       assert_false(e['target']['broken'])
  #     end
  #   end
  # end

  def test_estimate_min
    VCR.use_cassette("test_estimate_min") do
      res = Colrapi.estimate(@dataset_id, min: 1000)
      res['result'].each do |e|
        assert_true(e['estimate'] > 1000)
      end
    end
  end

  def test_estimate_max
    VCR.use_cassette("test_estimate_max") do
      res = Colrapi.estimate(@dataset_id, max: 10000)
      res['result'].each do |e|
        assert_true(e['estimate'] < 10000)
      end
    end
  end
end