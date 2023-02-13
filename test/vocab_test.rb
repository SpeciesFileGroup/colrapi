require_relative "test_helper"

class TestVocab < Test::Unit::TestCase

  def test_vocab
    VCR.use_cassette("test_vocab") do
      res = Colrapi.vocab
      assert_true(res.include? 'issue')
    end
  end

  def test_vocab_issues
    VCR.use_cassette("test_vocab_issues") do
      res = Colrapi.vocab(term: 'issue')
      assert_equal('not interpreted', res[0]['name'])
    end
  end

  def test_vocab_geotime
    VCR.use_cassette("test_vocab_geotime") do
      res = Colrapi.vocab(term: 'geotime')
      assert_true((
                    res[0].key? 'name' and
                    res[0].key? 'type' and
                    res[0].key? 'start' and
                    res[0].key? 'end' and
                    res[0].key? 'parent'))
    end
  end

  def test_vocab_geotime_Jurassic
    VCR.use_cassette("test_vocab_geotime_Jurassic") do
      res = Colrapi.vocab(term: 'geotime', subresource: 'Jurassic')
      assert_equal('Jurassic', res['name'])
    end
  end

  def test_vocab_geotime_Jurassic_children
    VCR.use_cassette("test_vocab_geotime_Jurassic_children") do
      res = Colrapi.vocab(term: 'geotime', subresource: 'Jurassic', children: true)
      assert_equal('UpperJurassic', res[0]['name'])
    end
  end

  def test_vocab_country
    VCR.use_cassette("test_vocab_country") do
      res = Colrapi.vocab(term: 'country')
      assert_true(res[0].key? 'iso2LetterCode')
    end
  end

  def test_vocab_country_nz
    VCR.use_cassette("test_vocab_country_nz") do
      res = Colrapi.vocab(term: 'country', subresource: 'nz')
      assert_equal('new zealand', res['name'])
    end
  end

  def test_vocab_area_tdwg_ill
    VCR.use_cassette("test_vocab_area_tdwg_ill") do
      res = Colrapi.vocab(term: 'area', subresource: 'tdwg:ill')
      assert_equal('Illinois', res['name'])
    end
  end

  def test_vocab_language
    VCR.use_cassette("test_vocab_language") do
      res = Colrapi.vocab(term: 'language')
      assert_true(res.key? 'lat')
    end
  end

  def test_vocab_language_lat
    VCR.use_cassette("test_vocab_language_lat") do
      res = Colrapi.vocab(term: 'language', subresource: 'lat')
      assert_equal('Latin', res)
    end
  end

  def test_vocab_nomstatus
    VCR.use_cassette("test_vocab_nomstatus") do
      res = Colrapi.vocab(term: 'nomstatus')
      assert_equal('nomen validum', res[0]['botanical'])
    end
  end

  def test_vocab_term
    VCR.use_cassette("test_vocab_term") do
      res = Colrapi.vocab(term: 'term')
      assert_true(res.include? 'dwc:Occurrence')
    end
  end

  def test_vocab_term_extinct
    VCR.use_cassette("test_vocab_term_extinct") do
      res = Colrapi.vocab(term: 'term', subresource: 'col:extinct')
      assert_equal('https://terms.catalogueoflife.org/extinct', res['qualifiedName'])
    end
  end
end