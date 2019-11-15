require 'test_helper'

class PyramidTest < ActiveSupport::TestCase
  test "attributes" do
    pyramid = Pyramid.new
    assert_equal 4, pyramid.grades.size
    assert_equal 1, pyramid.grades.first.climbs.size
  end
end
