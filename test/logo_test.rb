require_relative "test_helper"
require 'digest'

class TestLogo < Test::Unit::TestCase
  def test_logo
    VCR.use_cassette("test_logo") do
      md5 = Digest::MD5.new
      res = Colrapi.logo('9837')
      md5_hash = md5.update(res).to_s
      assert_equal('09aca07ec3c2c9001196fc3532acd25c', md5_hash)
    end
  end

  def test_logo_original
    VCR.use_cassette("test_logo_original") do
      md5 = Digest::MD5.new
      res = Colrapi.logo('9837', size: 'original')
      md5_hash = md5.update(res).to_s
      assert_equal('5a26983dfe97fd82e6a053427303f9b4', md5_hash)
    end
  end

  def test_logo_medium
    VCR.use_cassette("test_logo_medium") do
      md5 = Digest::MD5.new
      res = Colrapi.logo('9837', size: 'medium')
      md5_hash = md5.update(res).to_s
      assert_equal('46f74dfcf23adb9c4b2b13e591f66bb0', md5_hash)
    end
  end

  def test_logo_large
    VCR.use_cassette("test_logo_large") do
      md5 = Digest::MD5.new
      res = Colrapi.logo('9837', size: 'large')
      md5_hash = md5.update(res).to_s
      assert_equal('9f972281546c10c1f6f22d098cee433c', md5_hash)
    end
  end
end