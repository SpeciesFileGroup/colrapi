require_relative "test_helper"

class TestNameusagePattern < Test::Unit::TestCase
  def setup
    @col_ac22 = "9837"
  end

  def test_nameusage_pattern
    VCR.use_cassette("test_nameusage_pattern") do
      res = Colrapi.nameusage_pattern(@col_ac22, '[A-Z]rnithorhynchus anatinus')
      assert_equal('Ornithorhynchus anatinus', res[0]['name'])
    end
  end

  def test_nameusage_pattern_species
    VCR.use_cassette("test_nameusage_pattern_species") do
      res = Colrapi.nameusage_pattern(@col_ac22, '[A-Z]rnithorhynchus anatinus', rank: 'species')
      assert_equal('Ornithorhynchus anatinus', res[0]['name'])
    end
  end

  def test_nameusage_pattern_family
    VCR.use_cassette("test_nameusage_pattern_family") do
      res = Colrapi.nameusage_pattern(@col_ac22, '[A-Z]rnithorhynchus anatinus', rank: 'family')
      assert_equal(0, res.size)
    end
  end
end
