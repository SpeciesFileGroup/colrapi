require_relative "test_helper"
require 'digest'

class TestArchive < Test::Unit::TestCase
  def test_archive
    VCR.use_cassette("test_archive") do
      md5 = Digest::MD5.new
      res = Colrapi.archive('36223')
      md5_hash = md5.update(res).to_s
      assert_equal('a031f803279ae28d7c78c6b882ad58a1', md5_hash)
    end
  end
end