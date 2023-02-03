require_relative "test_helper"

class TestTaxon < Test::Unit::TestCase
  def setup
    @name = "Alces alces"
    @authorship = "(Linnaeus, 1758)"
    @taxon_id = 'BHC3'
    @dataset_id = "9837"
  end

  def test_taxon
    VCR.use_cassette("test_taxon") do
      res = Colrapi.taxon(@dataset_id, @taxon_id)
      assert_equal(@name, res['name']['scientificName'])
      assert_equal(@authorship, res['name']['authorship'])
    end
  end

  def test_taxon_classification
    VCR.use_cassette("test_taxon_classification") do
      res = Colrapi.taxon_classification(@dataset_id, @taxon_id)
      assert_equal('Alces', res[0]['name'])
      assert_equal('genus', res[0]['rank'])
      assert_equal('Capreolinae', res[1]['name'])
      assert_equal('subfamily', res[1]['rank'])
      assert_equal('Cervidae', res[2]['name'])
      assert_equal('family', res[2]['rank'])
      assert_equal('Artiodactyla', res[3]['name'])
      assert_equal('order', res[3]['rank'])
      assert_equal('Eutheria', res[4]['name'])
      assert_equal('infraclass', res[4]['rank'])
      assert_equal('Theria', res[5]['name'])
      assert_equal('subclass', res[5]['rank'])
      assert_equal('Mammalia', res[6]['name'])
      assert_equal('class', res[6]['rank'])
      assert_equal('Animalia', res[14]['name'])
      assert_equal('kingdom', res[14]['rank'])
    end
  end

  def test_taxon_distribution
    VCR.use_cassette("test_taxon_distribution") do
      res = Colrapi.taxon_distribution(@dataset_id, @taxon_id)
      assert_equal('Europe & Northern Asia (excluding China)', res[0]['area']['name'])
      assert_equal('native', res[0]['status'])
      assert_equal('Southern Asia', res[1]['area']['name'])
      assert_equal('native', res[1]['status'])
    end
  end

  def test_taxon_info
    VCR.use_cassette("test_taxon_info") do
      res = Colrapi.taxon_info(@dataset_id, @taxon_id)
      assert_equal(@name, res['taxon']['name']['scientificName'])
      assert_equal('accepted', res['taxon']['status'])
      assert_equal('RKW', res['taxon']['parentId'])
      assert_equal('2471c9d1-3b0b-4991-977e-2cbf1ff2b920', res['taxon']['referenceIds'][0])
      assert_equal('Alfred L. Gardner,Peter Grubb', res['taxon']['scrutinizer'])
      assert_equal(@dataset_id, res['source']['datasetKey'].to_s)
      assert_equal('180703', res['source']['sourceId'])
      assert_equal('2144', res['source']['sourceDatasetKey'].to_s)
      assert_equal('Cervus alces', res['synonyms']['heterotypic'][0]['name']['scientificName'])
      assert_equal('Europe & Northern Asia (excluding China)', res['distributions'][0]['area']['name'])
      assert_equal('native', res['distributions'][0]['status'])
      assert_equal('Eurasian Elk', res['vernacularNames'][0]['name'])
      assert_equal('eng', res['vernacularNames'][0]['language'])
      assert_equal('moose', res['vernacularNames'][1]['name'])
      assert_equal('eng', res['vernacularNames'][1]['language'])
      assert_equal('orignal', res['vernacularNames'][2]['name'])
      assert_equal('fra', res['vernacularNames'][2]['language'])
      assert_equal('1981', res['references']['930ad02b-e40f-49f1-a3a1-31d3695fdc56']['year'].to_s)
      assert_equal('Franzmann, Albert W. (1981). Alces alces. Mammalian Species, No. 154.',  res['references']['930ad02b-e40f-49f1-a3a1-31d3695fdc56']['citation'])
    end
  end

  def test_taxon_interaction
    VCR.use_cassette("test_taxon_interaction") do
      res = Colrapi.taxon_interaction('2317', '28472')
      assert_equal('Eragrostis curvula', res[0]['relatedTaxonScientificName'])
      assert_equal('eats', res[0]['type'])
      assert_equal('Themeda triandra', res[1]['relatedTaxonScientificName'])
      assert_equal('eats', res[1]['type'])
    end
  end

  # TODO: find a dataset with media
  def test_taxon_media

  end

  # TODO: find a dataset with RCC5 relations
  def test_taxon_relation

  end

  def test_taxon_source
    VCR.use_cassette("test_taxon_source") do
      res = Colrapi.taxon_source(@dataset_id, @taxon_id)
      assert_equal(@taxon_id, res['id'])
      assert_equal(@dataset_id, res['datasetKey'].to_s)
      assert_equal('180703', res['sourceId'])
      assert_equal('2144', res['sourceDatasetKey'].to_s)
    end
  end

  def test_taxon_synonyms
    VCR.use_cassette("test_taxon_synonyms") do
      res = Colrapi.taxon_synonyms(@dataset_id, @taxon_id)
      assert_equal('Cervus alces', res['heterotypic'][0]['name']['scientificName'])
    end
  end

  def test_taxon_treatment
    VCR.use_cassette("test_taxon_treatment") do
      res = Colrapi.taxon_treatment('49590', '03D087F29465E83AFCF39B19FA20FC96.taxon')
      assert_equal('<div><p>Key to females of Liposcelis group II-C species with fewer than seven ommatidia</p> <p>1 With 2 ommatidia in eye............................................................................................................................. 2</p> <p>-. With 3–6 ommatidia in eye (note exception for L. exigua)........................................................................ 3</p> <p>2 Areoles of vertex smooth........................................................ L. paetula Broadhead, 1950 (W. Palearctic)</p> <p>-. Areoles of vertex with numerous tubercles.......................................... L. parvula Badonnel, 1963 (Chile)</p> <p>3 With 7, but rarely 5 ommatidia in eye; head and thorax deep maroon brown, abdomen paler................................................................................................................................... L. exigua Badonnel, 1931 (Africa)</p> <p>-. With 3–6 ommatidia in eye; head and thorax not colored as above (paler)................................................ 4</p> <p>4 With 3–4 ommatidia in eye......................................................................................................................... 5</p> <p>-. With 5–6 ommatidia in eye......................................................................................................................... 7</p> <p>5 With 3 ommatidia in eye; vertex with sparse, heavy setae............... L. ayosae Lienhard, 1996 (Canary Is)</p> <p>-. With 4 ommatidia in eye; setae of vertex fine............................................................................................ 6</p> <p>6 Sculpture of vertex spindle-shaped areas with smooth surfaces; SI 23–28 µm........................................................................................................................................ L. obscura Broadhead, 1954 (England, Egypt)</p> <p>-. Sculpture of vertex spindle-shaped areas bearing very fine, dense tubercles oriented in longitudinal lines; SI 16–19 µm..................................................................................... L. tetrops Badonnel, 1986 a (Senegal)</p> <p>7 SE relatively long, acuminate distally....................................... L. pacifica Badonnel, 1986 b (W. Mexico)</p> <p>-. SE shorter, truncate or slightly flared at apex............................................................................................. 8</p> <p>8 Areoles of vertex obscure, finely granulate................................................................................................ 9</p> <p>-. Areoles of vertex distinct.......................................................................................................................... 10</p> <p>9 Body and appendages medium brown. Body length ca. 1.0 mm; SI ca. 18 µm............................................................................................................................................ L. teminensis Smithers, 1996 (W. Australia)</p> <p>-. Body very pale chamois brown. Body length 0.84–0.86 mm; SI ca. 24 µm................................................................................................................................................................. L. barrai Badonnel, 1969 (Gabon)</p> <p>10 SI extremely short, little longer than surrounding setae................ L. romeralensis Badonnel, 1967 (Chile)</p> <p>-. SI decidedly longer than surrounding setae.............................................................................................. 11</p> <p>11 Body red-brown throughout with lateral hypodermal dark brown pigment granules.................................................................................................................................................. L. lunae Badonnel, 1969 (Angola)</p> <p>-. Body color not as above, and lacking lateral hypodermal dark pigment granules................................... 12</p> <p>12. Thoracic setae SII not clearly differentiated; thoracic sternum II with 7 setae in anterior row............................................................................................................................. L. mira Badonnel, 1986 b (W. Mexico)</p> <p>-. Thoracic setae SII differentiated but shorter than SI; thoracic sternum II with 8–10 setae in anterior row..................................................................................................................................................................... 13</p> <p>13. Setae of vertex ~ 7 µm long; setae D not differentiated.............. L. bogotana Badonnel, 1986 c (Colombia)</p> <p>-. Setae of vertex 12–14 µm long; setae D differentiated...................................................... L. kipukae n. sp.</p></div>', res.force_encoding("utf-8"))
    end
  end

  def test_taxon_vernacular
    VCR.use_cassette("test_taxon_vernacular") do
      res = Colrapi.taxon_vernacular(@dataset_id, @taxon_id)
      assert_equal('Eurasian Elk', res[0]['name'])
      assert_equal('eng', res[0]['language'])
      assert_equal('moose', res[1]['name'])
      assert_equal('eng', res[1]['language'])
      assert_equal('orignal', res[2]['name'])
      assert_equal('fra', res[2]['language'])
    end
  end

end
