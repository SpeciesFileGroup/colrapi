require_relative "test_helper"

class TestParserMetadata < Test::Unit::TestCase

  def test_parser_metadata
    VCR.use_cassette("test_parser_metadata") do
      res = Colrapi.parser_metadata('https://api.checklistbank.org/dataset/1027.yaml', format: 'yaml')
      assert_equal('Scarabs', res['alias'])
    end
  end

end