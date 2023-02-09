require_relative "test_helper"

class TestNameList < Test::Unit::TestCase
  def setup
    @dataset_id = 49590
    @import_attempt = 1
    @result = 'Animalia|Arthropoda|Insecta|Liposcelididae|Liposcelis|Liposcelis bostrychophila Badonnel|Liposcelis deltachi Sommerman|Liposcelis kipukae|Liposcelis maunakea|Liposcelis nasus|Liposcelis rufa Broadhead|Liposcelis volcanorum|Psocodea|'
  end

  def test_name_list
    VCR.use_cassette("test_name_list") do
      res = Colrapi.name_list(@dataset_id, import_attempt: @import_attempt)
      assert_equal(@result, res.gsub(/\n/, '|'))
    end
  end
end