require_relative "test_helper"

class TestIdConverter < Test::Unit::TestCase
  def setup
    @int = 526387293
    @proquint = 'WP8ZFZ'
  end

  def test_parser_idconverter_encode
    VCR.use_cassette("test_parser_idconverter_encode") do
      res = Colrapi.parser_idconverter('encode', @int, 'proquint')
      assert_equal(@proquint, res)
    end
  end

  def test_parser_idconverter_decode
    VCR.use_cassette("test_parser_idconverter_decode") do
      res = Colrapi.parser_idconverter('decode', @proquint, 'integer')
      assert_equal(@int, res)
    end
  end
end
