require_relative "test_helper"

class TestParserName < Test::Unit::TestCase

  def test_parser_name
    VCR.use_cassette("test_parser_name") do
      res = Colrapi.parser_name('Acalypha macrostachya Jacq.')
      assert_true(res['parsed'])
    end
  end

  def test_parser_name_name
    VCR.use_cassette("test_parser_name") do
      res = Colrapi.parser_name('Acalypha macrostachya Jacq.')
      assert_equal('Acalypha macrostachya', res['scientificName'])
    end
  end

  def test_parser_name_rank
    VCR.use_cassette("test_parser_name") do
      res = Colrapi.parser_name('Acalypha macrostachya Jacq.')
      assert_equal('species', res['rank'])
    end
  end

  def test_parser_name_authorship
    VCR.use_cassette("test_parser_name") do
      res = Colrapi.parser_name('Acalypha macrostachya Jacq.')
      assert_equal('Jacq.', res['authorship'])
    end
  end

  def test_parser_name_genus
    VCR.use_cassette("test_parser_name") do
      res = Colrapi.parser_name('Acalypha macrostachya Jacq.')
      assert_equal('Acalypha', res['genus'])
    end
  end

  def test_parser_name_species
    VCR.use_cassette("test_parser_name") do
      res = Colrapi.parser_name('Acalypha macrostachya Jacq.')
      assert_equal('macrostachya', res['specificEpithet'])
    end
  end
end