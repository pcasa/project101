require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Service.new.valid?
  end
end
