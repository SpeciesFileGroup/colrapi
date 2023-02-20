require_relative "test_helper"

class TestDiff < Test::Unit::TestCase
  def setup
    @dataset1_id = '30405'
    @dataset2_id = '36223'
    @token = nil
    @user = ENV['CLB_USER']
    @password = ENV['CLB_PASS']
    unless @user.nil? or @password.nil?
      @token = Colrapi.user_login(@user, @password)
    end
    @result = '--- dataset_30405
+++ dataset_36223
@@ -3,3 +2,0 @@
-Clinopsocus New, 1972
-Clinopsocus nigrescens Mockford, 2018
-Elipsocidae
@@ -7 +4,7 @@
-Psocoptera
+Lachesillidae
+Prolachesilla
+Prolachesilla boliviana
+Prolachesilla casasolai
+Prolachesilla casasolaoides
+Prolachesilla oaxacana
+Psocodea
'
  end

  def test_diff
    unless @token.nil?
      VCR.use_cassette("test_diff") do
        res = Colrapi.diff(@dataset1_id, @dataset2_id, token: @token)
        assert_equal(@result, res)
      end
    end
  end
end