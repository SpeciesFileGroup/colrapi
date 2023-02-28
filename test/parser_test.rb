require_relative "test_helper"

class TestParser < Test::Unit::TestCase

  def test_parser
    VCR.use_cassette("test_parser") do
      res = Colrapi.parser
      assert_include(res, 'gazetteer')
    end
  end

  def test_parser_boolean
    VCR.use_cassette("test_parser_boolean") do
      res = Colrapi.parser(subresource: 'boolean', q: 'TRUE')
      assert_true(res[0]['parsed'])
    end
  end

  def test_parser_country
    VCR.use_cassette("test_parser_country") do
      @expected = ['CA', 'DE', 'MX']
      res = Colrapi.parser(subresource: 'country',
                           q: %w[Canada DEU Mexico])
      i = 0
      res.each do |r|
        assert_equal(r['parsed'], @expected[i])
        i += 1
      end
    end
  end

  def test_parser_datasettype
    VCR.use_cassette("test_parser_datasettype") do
      res = Colrapi.parser(subresource: 'datasettype', q: 'taxonomic')
      assert_equal('taxonomic', res[0]['parsed'])
    end
  end

  def test_parser_distributionstatus
    VCR.use_cassette("test_parser_distributionstatus") do
      res = Colrapi.parser(subresource: 'distributionstatus', q: 'native')
      assert_equal('native', res[0]['parsed'])
    end
  end

  # note: if date is not in ISO 8601 format, then the date parser seems to only parse years out of the string
  def test_parser_date_array
    VCR.use_cassette("test_parser_date_array") do
      @expected = ['2023-04-01', '2003', '2023', '2023']
      res = Colrapi.parser(subresource: 'date',
                           q: ['2023-04-01', 'Smith, 2003', 'April 2023', 'April 1, 2023'])
      i = 0
      res.each do |r|
        assert_equal(@expected[i], r['parsed'])
        i += 1
      end
    end
  end

  def test_parser_geotime
    VCR.use_cassette("test_parser_geotime") do
      res = Colrapi.parser(subresource: 'geotime', q: 'Jurassic')
      assert_equal(201.3, res[0]['parsed']['start'])
    end
  end

  def test_parser_gazetteer_array
    VCR.use_cassette("test_parser_gazetteer_array") do
      res = Colrapi.parser(subresource: 'gazetteer',
                           q: %w[tdwg iso fao longhurst teow iho mrgid text])
      res.each do |r|
        assert_true(r['parsable'])
      end
    end
  end

  def test_parser_integer
    VCR.use_cassette("test_parser_integer") do
      res = Colrapi.parser(subresource: 'integer', q: '839383')
      assert_equal(839383, res[0]['parsed'])
    end
  end

  def test_parser_language
    VCR.use_cassette("test_parser_language") do
      @expected = ['lat', 'spa', 'kor', 'zho', 'deu']
      res = Colrapi.parser(subresource: 'language', q: %w[Latin Spanish Korean Chinese German])
      i = 0
      res.each do |r|
        assert_equal(@expected[i], r['parsed']['code'])
        i += 1
      end
    end
  end

  def test_parser_license
    VCR.use_cassette("test_parser_license") do
      res = Colrapi.parser(subresource: 'license', q: 'cc0')
      assert_equal('cc0', res[0]['parsed'])
    end
  end

  def test_parser_lifezone
    VCR.use_cassette("test_parser_lifezone") do
      res = Colrapi.parser(subresource: 'lifezone', q: 'freshwater')
      assert_equal('freshwater', res[0]['parsed'])
    end
  end

  # recommended to use Colrapi.parser_name() instead which allows more parameters than just q
  def test_parser_simple_name
    VCR.use_cassette("test_parser_simple_name") do
      res = Colrapi.parser(subresource: 'name', q: 'Quercus alba')
      assert_equal('Quercus alba', res['scientificName'])
    end
  end

  def test_parser_mediatype
    VCR.use_cassette("test_parser_mediatype") do
      res = Colrapi.parser(subresource: 'mediatype', q: 'image')
      assert_equal('image', res[0]['parsed'])
    end
  end

  def test_parser_nomcode
    VCR.use_cassette("test_parser_nomcode") do
      res = Colrapi.parser(subresource: 'nomcode', q: 'iczn')
      assert_equal('zoological', res[0]['parsed'])
    end
  end

  def test_parser_nomstatus
    VCR.use_cassette("test_parser_nomstatus") do
      @expected = ['doubtful', 'unacceptable', 'doubtful', 'manuscript', 'acceptable']
      res = Colrapi.parser(subresource: 'nomstatus',
                           q: ['nom. dubium', 'homonym', 'nomen inquirendum', 'manuscript name', 'nomen legitimum'])
      i = 0
      res.each do |r|
        assert_equal(r['parsed'], @expected[i])
        i += 1
      end
    end
  end

  def test_parser_nomreltype
    VCR.use_cassette("test_parser_nomreltype") do
      res = Colrapi.parser(subresource: 'nomreltype', q: 'basionym')
      assert_equal('basionym', res[0]['parsed'])
    end
  end

  def test_parser_rank
    VCR.use_cassette("test_parser_rank") do
      @expected = ['subspecies', 'form', 'variety']
      res = Colrapi.parser(subresource: 'rank', q: ['subsp.', 'f.', 'var.'])
      i = 0
      res.each do |r|
        assert_equal(@expected[i], r['parsed'])
        i += 1
      end
    end
  end

  def test_parser_referencetype
    VCR.use_cassette("test_parser_referencetype") do
      res = Colrapi.parser(subresource: 'referencetype', q: 'nomenclatural')
      assert_equal('nomref', res[0]['parsed'])
    end
  end

  def test_parser_sex
    VCR.use_cassette("test_parser_sex") do
      res = Colrapi.parser(subresource: 'sex', q: 'f')
      assert_equal('female', res[0]['parsed'])
    end
  end

  def test_parser_sex_array
    VCR.use_cassette("test_parser_sex_array") do
      res = Colrapi.parser(subresource: 'sex', q: ['f', 'm', 'female'])
      assert_equal('male', res[1]['parsed'])
    end
  end

  def test_parser_taxonomicstatus
    VCR.use_cassette("test_parser_taxonomicstatus") do
      res = Colrapi.parser(subresource: 'taxonomicstatus', q: 'provisionally accepted')
      assert_equal('provisionally accepted', res[0]['parsed']['val'])
    end
  end

  def test_parser_treatmentformat
    VCR.use_cassette("test_parser_treatmentformat") do
      res = Colrapi.parser(subresource: 'treatmentformat', q: 'md')
      assert_equal('markdown', res[0]['parsed'])
    end
  end

  def test_parser_typestatus
    VCR.use_cassette("test_parser_typestatus") do
      res = Colrapi.parser(subresource: 'typestatus', q: 'h')
      assert_equal('holotype', res[0]['parsed'])
    end
  end

  def test_parser_uri
    VCR.use_cassette("test_parser_uri") do
      res = Colrapi.parser(subresource: 'uri', q: 'https://www.checklistbank.org')
      assert_equal('https://www.checklistbank.org', res[0]['parsed'])
    end
  end
end
