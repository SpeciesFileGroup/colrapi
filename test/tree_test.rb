require_relative "test_helper"

class TestTree < Test::Unit::TestCase
  def setup
    @dataset_id = "9837"
  end

  def test_tree
    VCR.use_cassette("test_tree") do
      res = Colrapi.tree(@dataset_id)
      assert_equal(2, res['total'])
      assert_equal('Biota', res['result'][0]['name'])
      assert_equal('Viruses', res['result'][1]['name'])
    end
  end

  def test_tree_offset_limit
    VCR.use_cassette("test_tree_offset_limit") do
      res = Colrapi.tree(@dataset_id, offset: 1, limit: 1)
      assert_equal(1, res['offset'])
      assert_equal(1, res['limit'])
      assert_equal(2, res['total'])
      assert_equal(@dataset_id, res['result'][0]['datasetKey'].to_s)
      assert_equal('V', res['result'][0]['id'])
      assert_equal('unranked', res['result'][0]['rank'])
      assert_equal('accepted', res['result'][0]['status'])
      assert_equal(28, res['result'][0]['childCount'])
      assert_equal('Viruses', res['result'][0]['name'])
      assert_equal('<i>Viruses</i>', res['result'][0]['labelHtml'])
    end
  end

  def test_tree_offset_limit_child
    VCR.use_cassette("test_tree_offset_limit_child") do
      res = Colrapi.tree(@dataset_id, taxon_id: 'H6', children: true, offset: 11, limit: 1)
      assert_equal(11, res['offset'])
      assert_equal(1, res['limit'])
      assert_equal(46, res['total'])
      assert_equal(@dataset_id, res['result'][0]['datasetKey'].to_s)
      assert_equal('6223S', res['result'][0]['id'])
      assert_equal('H6', res['result'][0]['parentId'])
      assert_equal('order', res['result'][0]['rank'])
      assert_equal('accepted', res['result'][0]['status'])
      assert_equal(4, res['result'][0]['childCount'])
      assert_equal('Glosselytrodea', res['result'][0]['name'])
      assert_equal('Glosselytrodea', res['result'][0]['labelHtml'])
    end
  end

  def test_tree_id
    VCR.use_cassette("test_tree_id") do
      res = Colrapi.tree(@dataset_id, taxon_id: '5T6MX')
      assert_equal(1, res.size)
      assert_equal('Biota', res[0]['name'])
    end
  end

  def test_tree_id_children_false
    VCR.use_cassette("test_tree_id_false") do
      res = Colrapi.tree(@dataset_id, taxon_id: '5T6MX', children: false)
      assert_equal(1, res.size)
      assert_equal('Biota', res[0]['name'])
    end
  end

  def test_tree_id_children_true
    VCR.use_cassette("test_tree_id_children_true") do
      res = Colrapi.tree(@dataset_id, taxon_id: '5T6MX', children: true)
      assert_equal(7, res['total'])
      assert_equal('Animalia', res['result'][0]['name'])
      assert_equal('Archaea', res['result'][1]['name'])
      assert_equal('Bacteria', res['result'][2]['name'])
      assert_equal('Chromista', res['result'][3]['name'])
      assert_equal('Fungi', res['result'][4]['name'])
      assert_equal('Plantae', res['result'][5]['name'])
      assert_equal('Protozoa', res['result'][6]['name'])
      assert_equal('kingdom', res['result'][0]['rank'])
      assert_equal('kingdom', res['result'][1]['rank'])
      assert_equal('kingdom', res['result'][2]['rank'])
      assert_equal('kingdom', res['result'][3]['rank'])
      assert_equal('kingdom', res['result'][4]['rank'])
      assert_equal('kingdom', res['result'][5]['rank'])
      assert_equal('kingdom', res['result'][6]['rank'])
      assert_equal('N', res['result'][0]['id'])
      assert_equal('R', res['result'][1]['id'])
      assert_equal('B', res['result'][2]['id'])
      assert_equal('C', res['result'][3]['id'])
      assert_equal('F', res['result'][4]['id'])
      assert_equal('P', res['result'][5]['id'])
      assert_equal('Z', res['result'][6]['id'])
      assert_equal(33, res['result'][0]['childCount'])
      assert_equal(2, res['result'][1]['childCount'])
      assert_equal(2, res['result'][2]['childCount'])
      assert_equal(14, res['result'][3]['childCount'])
      assert_equal(37, res['result'][4]['childCount'])
      assert_equal(8, res['result'][5]['childCount'])
      assert_equal(19, res['result'][6]['childCount'])
      assert_equal('accepted', res['result'][0]['status'])
      assert_equal('accepted', res['result'][1]['status'])
      assert_equal('accepted', res['result'][2]['status'])
      assert_equal('accepted', res['result'][3]['status'])
      assert_equal('accepted', res['result'][4]['status'])
      assert_equal('accepted', res['result'][5]['status'])
      assert_equal('accepted', res['result'][6]['status'])
      assert_equal('5T6MX', res['result'][0]['parentId'])
      assert_equal('5T6MX', res['result'][1]['parentId'])
      assert_equal('5T6MX', res['result'][2]['parentId'])
      assert_equal('5T6MX', res['result'][3]['parentId'])
      assert_equal('5T6MX', res['result'][4]['parentId'])
      assert_equal('5T6MX', res['result'][5]['parentId'])
      assert_equal('5T6MX', res['result'][6]['parentId'])
      assert_equal('Cavalier-Smith, 2002', res['result'][2]['authorship'])
    end
  end
end
