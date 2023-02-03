require_relative "test_helper"

class TestTaxonIds < Test::Unit::TestCase
  def setup
    @dataset_id = "49590"
    @id_list = "03D087F29465E83AFCF39B19FA20FC96.taxon\n03D087F29464E838FCF39EE4FCC7FDCD.taxon\n03D087F2946BE837FCF39A79FEE9FA6B.taxon\n03D087F29468E837FCF39DF1FE30FBED.taxon\n03D087F29464E839FCF39CACFA25FB0D.taxon\n03D087F2946FE834FCF39BF9FD88FC65.taxon\n03D087F29466E83DFCF39DFBFA20FE3D.taxon\n03D087F2946BE837FCF39804FA20F898.taxon\nx4\nx6\nx8\nxB\nxD\n"
  end
  def test_taxon
    VCR.use_cassette("test_taxon_ids") do
      res = Colrapi.taxon_ids(@dataset_id)
      assert_equal(@id_list, res)
    end
  end

end
