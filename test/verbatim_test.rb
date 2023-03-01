require_relative "test_helper"

class TestVerbatim < Test::Unit::TestCase
  def setup
    @dataset_id = "49590"
  end

  def test_verbatim
    VCR.use_cassette("test_verbatim") do
      res = Colrapi.verbatim(@dataset_id)
      assert_true(res['result'][0].key? 'terms')
    end
  end

  def test_verbatim_offset
    VCR.use_cassette("test_verbatim_offset_limit") do
      res = Colrapi.verbatim(@dataset_id, offset: 5, limit: 2)
      assert_equal(5, res['offset'])
    end
  end

  def test_verbatim_limit
    VCR.use_cassette("test_verbatim_offset_limit") do
      res = Colrapi.verbatim(@dataset_id, offset: 5, limit: 2)
      assert_equal(2, res['limit'])
    end
  end

  def test_verbatim_total
    VCR.use_cassette("test_verbatim_offset_limit") do
      res = Colrapi.verbatim(@dataset_id, offset: 5, limit: 2)
      assert_equal(38, res['total'])
    end
  end

  def test_verbatim_id
    VCR.use_cassette("test_verbatim_id") do
      res = Colrapi.verbatim(@dataset_id, verbatim_id: '4')
      assert_equal('Psocodea', res['terms']['dwc:order'])
    end
  end

  def test_verbatim_issue
    VCR.use_cassette("test_verbatim_issue") do
      res = Colrapi.verbatim(@dataset_id, issue: 'citation authors unparsed')
      assert_equal(8, res['total'])
    end
  end

  def test_verbatim_q
    VCR.use_cassette("test_verbatim_q") do
      res = Colrapi.verbatim(@dataset_id, q: 'Liposcelis volcanorum', type: 'dwc:Taxon')
      assert_equal('Liposcelis volcanorum', res['result'][0]['terms']['dwc:scientificName'])
    end
  end

  def test_verbatim_type
    VCR.use_cassette("test_verbatim_type") do
      res = Colrapi.verbatim(@dataset_id, type: 'dwc:Taxon')
      res['result'].each do |v|
        assert_equal('dwc:Taxon', v['type'])
      end
    end
  end

  def test_verbatim_term
    VCR.use_cassette("test_verbatim_term") do
      res = Colrapi.verbatim(@dataset_id, term: 'dwc:order', limit: 100)
      res['result'].each do |v|
        assert_true(v['terms'].key? 'dwc:order')
      end
    end
  end

  def test_verbatim_term_op_and
    VCR.use_cassette("test_verbatim_term_op_and") do
      res = Colrapi.verbatim(@dataset_id, term: ['dwc:order', 'dcterms:format'], term_operator: 'and', limit: 100)
      assert_equal(0, res['total'])
    end
  end

  def test_verbatim_term_op_or
    VCR.use_cassette("test_verbatim_term_op_or") do
      res = Colrapi.verbatim(@dataset_id, term: ['dwc:order', 'dcterms:format'], term_operator: 'or', limit: 100)
      assert_equal(30, res['total'])
    end
  end
end