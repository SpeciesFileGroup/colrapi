require_relative "test_helper"

class TestNameusageSuggest < Test::Unit::TestCase
  def setup
    @col_ac22 = '9837'
  end

  def test_nameusage_suggest
    VCR.use_cassette("test_nameusage_suggest") do
      res = Colrapi.nameusage_suggest(@col_ac22, 'Alces alc', max_rank: 'subspecies', limit: 1)
      assert_equal('Alces alces alces', res['suggestions'][0]['match'])
    end
  end

  def test_nameusage_suggest_limit
    VCR.use_cassette("test_nameusage_suggest") do
      res = Colrapi.nameusage_suggest(@col_ac22, 'Alces alc', max_rank: 'subspecies', limit: 1)
      assert_equal(1, res['suggestions'].size)
    end
  end

  def test_nameusage_suggest_rank
    VCR.use_cassette("test_nameusage_suggest") do
      res = Colrapi.nameusage_suggest(@col_ac22, 'Alces alc', max_rank: 'subspecies', limit: 1)
      assert_equal('subspecies',  res['suggestions'][0]['rank'])
    end
  end
end