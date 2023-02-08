require_relative "test_helper"
require_relative "../lib/colrapi"

class TestDataset < Test::Unit::TestCase
  def setup
    @dataset_id = "9837"
  end

  def test_dataset_id
    VCR.use_cassette("test_dataset_id") do
      res = Colrapi.dataset(dataset_id: @dataset_id)
      assert_equal('COL22', res['alias'])
    end
  end

  def test_dataset_id_attempt
    VCR.use_cassette("test_dataset_id_attempt") do
      res = Colrapi.dataset(dataset_id: '1027', attempt: 100)
      assert_equal('2022-12-01', res['issued'])
    end
  end

  def test_dataset_offset
    VCR.use_cassette("test_dataset_offset_limit") do
      res = Colrapi.dataset(offset: 2848, limit: 6)
      assert_equal(2848, res['offset'])
    end
  end

  def test_dataset_limit
    VCR.use_cassette("test_dataset_offset_limit") do
      res = Colrapi.dataset(offset: 2848, limit: 6)
      assert_equal(6, res['limit'])
    end
  end

  def test_dataset_q
    VCR.use_cassette("test_dataset_q") do
      res = Colrapi.dataset(q: "World Scarabaeidae Database")
      assert_equal("World Scarabaeidae Database", res['result'][0]['title'])
    end
  end

  def test_dataset_alias
    VCR.use_cassette("test_dataset_alias") do
      res = Colrapi.dataset(short_title: 'Scarabs')
      assert_equal("World Scarabaeidae Database", res['result'][0]['title'])
    end
  end

  def test_dataset_code
    VCR.use_cassette("test_dataset_code") do
      res = Colrapi.dataset(code: 'botanical', limit: 3)
      res['result'].each do |d|
        endpoint =  "dataset/#{d['key']}/settings"
        subquery = Colrapi::Request.new(endpoint: endpoint).perform
        assert_equal('botanical', subquery['nomenclatural code'])
      end
    end
  end

  # must be signed in to view private datasets, so total should be 0
  def test_dataset_private
    VCR.use_cassette("test_dataset_private") do
      res = Colrapi.dataset(private: true)
      assert_equal(0, res['total'])
    end
  end

  def test_dataset_released_from
    VCR.use_cassette("test_dataset_released_from") do
      res = Colrapi.dataset(released_from: 3)
      res['result'].each do |d|
        assert_equal(3, d['sourceKey'])
      end
    end
  end

  # might break in future if CoL source datasets start contributing to other projects
  #   also tests has_source_dataset
  def test_dataset_contributes_to
    VCR.use_cassette("test_dataset_contributes_to") do
      res = Colrapi.dataset(contributes_to: 3)
      res['result'].each do |d|
        endpoint = "/dataset?limit=1000&hasSourceDataset=#{d['key']}&origin=PROJECT"
        subquery = Colrapi::Request.new(endpoint: endpoint).perform
        assert_equal(3, subquery['result'][0]['key'])
      end
    end
  end

  def test_dataset_has_gbif_id_true
    VCR.use_cassette("test_dataset_has_gbif_id_true") do
      res = Colrapi.dataset(has_gbif_id: true)
      res['result'].each do |d|
        assert_true(d.key? 'gbifKey')
      end
    end
  end

  def test_dataset_has_gbif_id_false
    VCR.use_cassette("test_dataset_has_gbif_id_false") do
      res = Colrapi.dataset(has_gbif_id: false)
      res['result'].each do |d|
        assert_false(d.key? 'gbifKey')
      end
    end
  end

  def test_dataset_gbif_id
    VCR.use_cassette("test_dataset_gbif_id") do
      res = Colrapi.dataset(gbif_id: 'e01b0cbb-a10a-420c-b5f3-a3b20cc266ad')
      assert_equal('e01b0cbb-a10a-420c-b5f3-a3b20cc266ad', res['result'][0]['gbifKey'])
    end
  end

  def test_dataset_gbif_publisher_id
    VCR.use_cassette("test_dataset_gbif_publisher_id") do
      res = Colrapi.dataset(gbif_publisher_id: '47a779a6-a230-4edd-b787-19c3d2c80ab5')
      res['result'].each do |d|
        assert_equal('47a779a6-a230-4edd-b787-19c3d2c80ab5', d['gbifPublisherKey'])
      end
    end
  end

  def test_dataset_editor
    VCR.use_cassette("test_dataset_editor") do
      user = 102
      endpoint = "/user/#{user}"
      subquery = Colrapi::Request.new(endpoint: endpoint).perform
      res = Colrapi.dataset(editor: user)
      res['result'].each do |d|
        assert_true(subquery['editor'].include? d['key'])
      end
    end
  end

  def test_dataset_modified_by
    VCR.use_cassette("test_dataset_modified_by") do
      user = 103
      res = Colrapi.dataset(modified_by: user)
      res['result'].each do |d|
        assert_equal(user, d['modifiedBy'])
      end
    end
  end

  def test_dataset_origin
    VCR.use_cassette("test_dataset_origin") do
      res = Colrapi.dataset(origin: 'project')
      res['result'].each do |d|
        assert_equal('project', d['origin'])
      end
    end
  end

  def test_dataset_license
    VCR.use_cassette("test_dataset_license") do
      res = Colrapi.dataset(license: 'cc0')
      res['result'].each do |d|
        assert_equal('cc0', d['license'])
      end
    end
  end

  def test_dataset_row_type
    VCR.use_cassette("test_dataset_row_type") do
      res = Colrapi.dataset(row_type: 'col:TypeMaterial')
      res['result'].each do |d|
        endpoint = "/dataset/#{d['key']}/verbatim?limit=0&type=col%3ATypeMaterial"
        subquery = Colrapi::Request.new(endpoint: endpoint).perform
        assert_true(subquery['total'] > 0)
      end
    end
  end

  def test_dataset_created_after
    VCR.use_cassette("test_dataset_created_after") do
      res = Colrapi.dataset(created_after: '3000-01-01')
      assert_equal(0, res['total'])
      end
    end

  def test_dataset_created_before
    VCR.use_cassette("test_dataset_created_before") do
      res = Colrapi.dataset(created_before: '2019-11-21', sort_by: 'created', reverse: true)
      assert_equal(3, res['result'][0]['key'])
    end
  end

  def test_dataset_modified_after
    VCR.use_cassette("test_dataset_modified_after") do
      res = Colrapi.dataset(modified_after: '3000-01-01')
      assert_equal(0, res['total'])
    end
  end

  def test_dataset_modified_before
    VCR.use_cassette("test_dataset_modified_before") do
      res = Colrapi.dataset(modified_before: '2019-12-31')
      assert_equal(3, res['total'])
    end
  end

  def test_dataset_min_size
    VCR.use_cassette("test_dataset_min_size") do
      res = Colrapi.dataset(min_size: 4716120)
      assert_true(res['result'][0]['size'] > 4716120)
    end
  end
end
