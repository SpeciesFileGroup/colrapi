require_relative "test_helper"
require 'digest'

class TestArchive < Test::Unit::TestCase
  def test_archive
    VCR.use_cassette("test_archive") do
      md5 = Digest::MD5.new
      res = Colrapi.archive('36223', attempt: 71)
      md5_hash = md5.update(res).to_s
      assert_equal('3b9e9e8fd593dfa74ec8e745f97912f6', md5_hash)
    end
  end
end