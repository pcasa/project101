require 'test_helper'

class SpecialServiceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert SpecialService.new.valid?
  end
end
