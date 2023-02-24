require_relative "test_helper"

class TestAssembly < Test::Unit::TestCase

  def test_assembly
    VCR.use_cassette("test_assembly") do
      res = Colrapi.assembly('3')
      assert_true(res['completed'] >= 0)
    end
  end
end
