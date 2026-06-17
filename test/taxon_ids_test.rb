require_relative "test_helper"

class TestTaxonIds < Test::Unit::TestCase
  def setup
    @dataset_id = "49590"
    @id_list = %w[35270FB8.psocoptera.order E7C3192D.liposcelididae.family 03D087F29465E83AFCF39B19FA20FC96.taxon 03D087F29464E838FCF39EE4FCC7FDCD.taxon 03D087F2946BE837FCF39A79FEE9FA6B.taxon 03D087F29468E837FCF39DF1FE30FBED.taxon 03D087F29464E839FCF39CACFA25FB0D.taxon 03D087F2946FE834FCF39BF9FD88FC65.taxon 03D087F29466E83DFCF39DFBFA20FE3D.taxon 03D087F2946BE837FCF39804FA20F898.taxon]
  end
  def test_taxon
    VCR.use_cassette("test_taxon_ids") do
      res = Colrapi.taxon_ids(@dataset_id)
      res.split(/\n/).each do |r|
        assert_include(@id_list, r)
      end
    end
  end

end
