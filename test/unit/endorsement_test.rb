require 'test_helper'

class EndorsementTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Endorsement.new.valid?
  end
end
