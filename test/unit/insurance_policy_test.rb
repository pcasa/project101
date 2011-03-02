require 'test_helper'

class InsurancePolicyTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert InsurancePolicy.new.valid?
  end
end
