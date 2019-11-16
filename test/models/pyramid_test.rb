require 'test_helper'

class PyramidTest < ActiveSupport::TestCase
  test "attributes" do
    pyramid = Pyramid.new
    assert_equal 0, pyramid.pyramid_grades.size
  end

  test ".new_from_redpoint" do
    pyramid = Pyramid.new_from_redpoint("5.11c")
    assert_equal 4, pyramid.pyramid_grades.size
    assert_equal ["5.12b"], pyramid.pyramid_grades.first.climbs.map(&:name)
    assert_equal ["5.12a", "5.12a"], pyramid.pyramid_grades.second.climbs.map(&:name)
    assert_equal ["5.11d", "5.11d", "5.11d", "5.11d"], pyramid.pyramid_grades.third.climbs.map(&:name)
    assert_equal ["5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c"], pyramid.pyramid_grades.fourth.climbs.map(&:name)
  end
end
