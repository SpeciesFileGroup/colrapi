require_relative "test_helper"

class TestNameTree < Test::Unit::TestCase
  def setup
    @dataset_id = 49590
    @import_attempt = 1
    @result = 'Animalia [kingdom]|  Arthropoda [phylum]|    Insecta [class]|      Psocodea [order]|        Liposcelididae [family]|          Liposcelis [genus]|            Liposcelis bostrychophila Badonnel [species]|            Liposcelis deltachi Sommerman [species]|            Liposcelis kipukae [species]|            Liposcelis maunakea [species]|            Liposcelis nasus [species]|            Liposcelis rufa Broadhead [species]|            Liposcelis volcanorum [species]|'
  end

  def test_name_tree
    VCR.use_cassette("test_name_tree") do
      res = Colrapi.name_tree(@dataset_id, import_attempt: @import_attempt)
      assert_equal(@result, res.gsub(/\n/, '|'))
    end
  end
end