require_relative "test_helper"

class TestDecision < Test::Unit::TestCase
  def setup
    @dataset_id = '9837'
  end

  def test_decision
    VCR.use_cassette("test_decision") do
      res = Colrapi.decision(@dataset_id)
      assert_true(res['result'][0].key? 'subject')
    end
  end

  def test_decision_offset
    VCR.use_cassette("test_decision_offset_limit") do
      res = Colrapi.decision(@dataset_id, offset: 5, limit: 3)
      assert_equal(5, res['offset'])
    end
  end

  def test_decision_limit
    VCR.use_cassette("test_decision_offset_limit") do
      res = Colrapi.decision(@dataset_id, offset: 5, limit: 3)
      assert_equal(3, res['limit'])
    end
  end

  def test_decision_rank
    VCR.use_cassette("test_decision_rank") do
      res = Colrapi.decision(@dataset_id, rank: 'family')
      res['result'].each do |d|
        assert_equal('family', d['subject']['rank'])
      end
    end
  end

  def test_decision_modified_by
    VCR.use_cassette("test_decision_modified_by") do
      res = Colrapi.decision(@dataset_id, modified_by: 103)
      res['result'].each do |d|
        assert_equal(103, d['modifiedBy'])
      end
    end
  end

  def test_decision_broken
    VCR.use_cassette("test_decision_broken") do
      res = Colrapi.decision(@dataset_id, broken: true)
      res['result'].each do |d|
        assert_equal(true, d['subject']['broken'])
      end
    end
  end

  def test_decision_subject_dataset_id
    VCR.use_cassette("test_decision_subject_dataset_id") do
      res = Colrapi.decision(@dataset_id, subject_dataset_id: '1101')
      res['result'].each do |d|
        assert_equal('1101', d['subjectDatasetKey'].to_s)
      end
    end
  end

  def test_decision_mode
    VCR.use_cassette("test_decision_mode") do
      res = Colrapi.decision(@dataset_id, mode: 'block')
      res['result'].each do |d|
        assert_equal('block', d['mode'].to_s)
      end
    end
  end

  # this may fail in the future because I'm not sure if subject=true refers strictly to bare names
  def test_decision_subject
    VCR.use_cassette("test_decision_subject") do
      res = Colrapi.decision('3', subject: true)
      if res['total'] > 0
        res['result'].each do |d|
          assert_equal('bare name', d['subject']['status'])
        end
      end
    end
  end

  def test_decision_id
    VCR.use_cassette("test_decision_id") do
      res = Colrapi.decision(@dataset_id, decision_id: 470848)
      assert_equal(470848, res['id'])
    end
  end
end