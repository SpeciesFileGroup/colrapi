require_relative "test_helper"

class TestIssues < Test::Unit::TestCase
  def setup
    @dataset_id = "1101"
  end

  def test_issues
    VCR.use_cassette("test_issues") do
      res = Colrapi.issues(@dataset_id)
      assert_true(res.key? 'issuesCount')
    end
  end

  def test_issues_duplicate_name
    VCR.use_cassette("test_issues_duplicate_name") do
      res = Colrapi.issues(@dataset_id, issue: 'duplicate name')
      res['result'].each do |r|
        assert_equal('duplicate name', r['issues'][0])
      end
    end
  end

  def test_issues_interpreted_duplicate_name
    VCR.use_cassette("test_issues_interpreted_duplicate_name") do
      res = Colrapi.issues(@dataset_id, issue: 'duplicate name', mode: 'interpreted')
      res['result'].each do |r|
        assert_true((r.include? 'usage' and r['issues'][0] == 'duplicate name'))
      end
    end
  end

  def test_issues_unmatched_ref_brackets
    VCR.use_cassette("test_issues_unmatched_ref_brackets") do
      res = Colrapi.issues(@dataset_id, issue: 'unmatched reference brackets')
      res['result'].each do |r|
        assert_equal('unmatched reference brackets', r['issues'][0])
      end
    end
  end

  # TODO: add references test when issue is resolved: https://github.com/CatalogueOfLife/backend/issues/1202
end