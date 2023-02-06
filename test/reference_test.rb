require_relative "test_helper"

class TestReference < Test::Unit::TestCase
  def setup
    @reference_id = '00c43b69-a203-417c-ac75-74d96f8db2b6'
    @dataset_id = "9837"
  end

  def test_reference_citation
    VCR.use_cassette("test_reference") do
      res = Colrapi.reference(@dataset_id)
      assert_equal('Actas Soc. Esp. Hist. Nat. ((1898))', res['result'][0]['citation'])
    end
  end

  def test_reference_year
    VCR.use_cassette("test_reference") do
      res = Colrapi.reference(@dataset_id)
      assert_equal(1898, res['result'][0]['year'])
    end
  end

  def test_reference_author_family
    VCR.use_cassette("test_reference") do
      res = Colrapi.reference(@dataset_id)
      assert_equal('Durand', res['result'][1]['csl']['author'][0]['family'])
    end
  end

  def test_reference_offset
    VCR.use_cassette("test_reference_offset_limit") do
      res = Colrapi.reference(@dataset_id, offset: 3838, limit: 2)
      assert_equal(3838, res['offset'])
    end
  end

  def test_reference_limit
    VCR.use_cassette("test_reference_offset_limit") do
      res = Colrapi.reference(@dataset_id, offset: 3838, limit: 2)
      assert_equal(2, res['limit'])
    end
  end

  def test_reference_total
    VCR.use_cassette("test_reference_offset_limit") do
      res = Colrapi.reference(@dataset_id, offset: 3838, limit: 2)
      assert_equal(1273457, res['total'])
    end
  end

  def test_reference_by_id_title
    VCR.use_cassette("test_reference_by_id") do
      res = Colrapi.reference(@dataset_id, reference_id: @reference_id)
      assert_equal('In: Voyage de Ch. Alluaud et R. Jeannel en Afrique orientale: Vol. 2 Pg. 93',
                   res['csl']['container-title'])
    end
  end

  def test_reference_by_id_author_family
    VCR.use_cassette("test_reference_by_id") do
      res = Colrapi.reference(@dataset_id, reference_id: @reference_id)
      assert_equal('Meyrick', res['csl']['author'][0]['family'])
    end
  end

  def test_reference_by_id_year
    VCR.use_cassette("test_reference_by_id") do
      res = Colrapi.reference(@dataset_id, reference_id: @reference_id)
      assert_equal(1920, res['year'])
    end
  end

  def test_reference_orphans_title
    VCR.use_cassette("test_reference_orphans") do
      res = Colrapi.reference(@dataset_id, subresource: 'orphans')
      assert_equal('Brewster’s Edinburgh Encyclopedia Volume IX [part I]',
                   res['result'][0]['csl']['container-title'])
    end
  end

  def test_reference_orphans_year
    VCR.use_cassette("test_reference_orphans") do
      res = Colrapi.reference(@dataset_id, subresource: 'orphans')
      assert_equal(1815, res['result'][0]['year'])
    end
  end

  def test_reference_orphans_author_fmaily
    VCR.use_cassette("test_reference_orphans") do
      res = Colrapi.reference(@dataset_id, subresource: 'orphans')
      assert_equal('Leach', res['result'][0]['csl']['author'][0]['family'])
    end
  end

  def test_reference_orphans_offset
    VCR.use_cassette("test_reference_orphans_offset_limit") do
      res = Colrapi.reference(@dataset_id, subresource: 'orphans', offset: 5, limit: 3)
      assert_equal(5, res['offset'])
    end
  end

  def test_reference_orphans_limit
    VCR.use_cassette("test_reference_orphans_offset_limit") do
      res = Colrapi.reference(@dataset_id, subresource: 'orphans', offset: 5, limit: 3)
      assert_equal(3, res['limit'])
    end
  end

  def test_reference_orphans_total
    VCR.use_cassette("test_reference_orphans_offset_limit") do
      res = Colrapi.reference(@dataset_id, subresource: 'orphans', offset: 5, limit: 3)
      assert_equal(4, res['total'])
    end
  end
end

