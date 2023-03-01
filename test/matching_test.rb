require_relative "test_helper"

class TestMatching < Test::Unit::TestCase
  def setup
    @name = "Alces alces"
    @authorship = "(Linnaeus, 1758)"
    @homonym = 'Ficus variegata'
    @genus = 'Acuera'
    @subgenus = 'Acuera (Acuera)'
    @taxon_id = 'BHC3'
    @dataset_id = "9837"
  end

  def test_matching_name
    VCR.use_cassette("test_matching_Alces_alces") do
      res = Colrapi.matching(@dataset_id, name: @name)
      assert_equal(@name, res['usage']['name'])
    end
  end

  def test_matching_name_type_ambiguous
    VCR.use_cassette("test_matching_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym)
      assert_equal('ambiguous', res['type'])
    end
  end

  def test_matching_homonym_scoped_kingdom
    VCR.use_cassette("test_matching_Plantae_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_kingdom: 'Plantae')
      assert_equal('Blume', res['usage']['authorship'])
    end
  end

  def test_matching_homonym_scoped_phylum
    VCR.use_cassette("test_matching_Animalia_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_phylum: 'Mollusca')
      assert_equal('Röding, 1798', res['usage']['authorship'])
    end
  end

  def test_matching_homonym_scoped_class
    VCR.use_cassette("test_matching_Gastropoda_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_class: 'Gastropoda')
      assert_equal('Röding, 1798', res['usage']['authorship'])
    end
  end

  def test_matching_homonym_scoped_subclass
    VCR.use_cassette("test_matching_Caenogastropoda_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_subclass: 'Caenogastropoda')
      assert_equal('Röding, 1798', res['usage']['authorship'])
    end
  end

  def test_matching_homonym_scoped_order
    VCR.use_cassette("test_matching_Littorinimorpha_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_order: 'Littorinimorpha')
      assert_equal('Röding, 1798', res['usage']['authorship'])
    end
  end

  def test_matching_homonym_scoped_superfamily
    VCR.use_cassette("test_matching_Ficoidea_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_superfamily: 'Ficoidea')
      assert_equal('Röding, 1798', res['usage']['authorship'])
    end
  end

  def test_matching_homonym_scoped_family
    VCR.use_cassette("test_matching_Ficidae_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_family: 'Ficidae')
      assert_equal('Röding, 1798', res['usage']['authorship'])
    end
  end

  def test_matching_homonym_scoped_family_Moraceae
    VCR.use_cassette("test_matching_Moraceae_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_family: 'Moraceae')
      assert_equal('Blume', res['usage']['authorship'])
    end
  end

  def test_matching_homonym_scoped_genus_ambiguous
    VCR.use_cassette("test_matching_Ficus_Ficus_variegata") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_genus: 'Ficus')
      assert_equal('ambiguous', res['type'])
    end
  end

  def test_matching_homonym_scoped_genus_authorship
    VCR.use_cassette("test_matching_Ficus_Ficus_variegata_Röding") do
      res = Colrapi.matching(@dataset_id, name: @homonym, within_genus: 'Ficus', authorship: 'Röding, 1798')
      assert_equal('Röding, 1798', res['usage']['authorship'])
    end
  end

  def test_matching_subgenus_Acuera_Acuera_rank
    VCR.use_cassette("test_matching_Acuera_subgenus") do
      res = Colrapi.matching(@dataset_id, name: @subgenus, rank: 'subgenus')
      assert_equal('Acuera (Acuera)', res['usage']['name'])
    end
  end

  def test_matching_Isoptera
    VCR.use_cassette("test_matching_Isoptera_ambiguous") do
      res = Colrapi.matching(@dataset_id, name: 'Isoptera')
      assert_equal('ambiguous', res['type'])
    end
  end
end
