require_relative "test_helper"

class TestTree < Test::Unit::TestCase
  def setup
    @dataset_id = "9837"
  end

  def test_tree
    VCR.use_cassette("test_tree") do
      res = Colrapi.tree(@dataset_id)
      assert_equal(2, res['total'])
    end
  end

  def test_tree_biota
    VCR.use_cassette("test_tree") do
      res = Colrapi.tree(@dataset_id)
      assert_equal('Biota', res['result'][0]['name'])
    end
  end

  def test_tree_viruses
    VCR.use_cassette("test_tree") do
      res = Colrapi.tree(@dataset_id)
      assert_equal('Viruses', res['result'][1]['name'])
    end
  end

  def test_tree_offset
    VCR.use_cassette("test_tree_offset_limit") do
      res = Colrapi.tree(@dataset_id, taxon_id: 'N', children: true, offset: 3, limit: 5)
      assert_equal(3, res['offset'])
    end
  end

  def test_tree_limit
    VCR.use_cassette("test_tree_offset_limit") do
      res = Colrapi.tree(@dataset_id, taxon_id: 'N', children: true, offset: 3, limit: 5)
      assert_equal(5, res['limit'])
    end
  end

  def test_tree_id
    VCR.use_cassette("test_tree_id") do
      res = Colrapi.tree(@dataset_id, taxon_id: '5T6MX')
      assert_equal('Biota', res[0]['name'])
    end
  end

  def test_tree_id_children_false
    VCR.use_cassette("test_tree_id_false") do
      res = Colrapi.tree(@dataset_id, taxon_id: '5T6MX', children: false)
      assert_equal('Biota', res[0]['name'])
    end
  end

  def test_tree_id_children_true
    VCR.use_cassette("test_tree_id_children_true") do
      res = Colrapi.tree(@dataset_id, taxon_id: '5T6MX', children: true)
      res['result'].each do |r|
        assert_equal('kingdom', r['rank'])
      end
    end
  end
end
