require 'test_helper'

class VendorTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Vendor.new.valid?
  end
end
