require 'test_helper'

class ServiceGroupTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ServiceGroup.new.valid?
  end
end
