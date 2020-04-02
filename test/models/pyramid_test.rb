# frozen_string_literal: true

require "test_helper"

class PyramidTest < ActiveSupport::TestCase
  test "attributes" do
    pyramid = Pyramid.new
    assert_equal 0, pyramid.pyramid_grades.size
  end

  test ".new_from_redpoint" do
    tr = Discipline.create!(name: "Indoor Top Rope")
    pyramid = Pyramid.new_from_redpoint("5.11c", tr)
    assert_equal 4, pyramid.pyramid_grades.size
    assert_equal ["5.12b"], pyramid.pyramid_grades.first.climbs.map(&:name)
    assert_equal ["5.12a", "5.12a"], pyramid.pyramid_grades.second.climbs.map(&:name)
    assert_equal ["5.11d", "5.11d", "5.11d", "5.11d"], pyramid.pyramid_grades.third.climbs.map(&:name)
    assert_equal ["5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c"], pyramid.pyramid_grades.fourth.climbs.map(&:name)
  end

  test ".new_from_climbs no climbs" do
    tr = Discipline.create!(name: "Indoor Top Rope")
    pyramid = Pyramid.new_from_climbs(tr)
    assert_equal 4, pyramid.pyramid_grades.size
    assert_equal ["5.9"], pyramid.pyramid_grades.first.climbs.map(&:name)
  end

  test ".new_from_climbs" do
    tr = Discipline.create!(name: "Indoor Top Rope")
    Climb.create!(grade: "5.10a", discipline: tr)
    pyramid = Pyramid.new_from_climbs(tr)
    assert_equal 4, pyramid.pyramid_grades.size

    climb = pyramid.pyramid_grades.first.climbs.first
    assert_equal "5.10d", climb.name
    assert_not climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.last.climbs.first
    assert_equal "5.10a", climb.name
    assert climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.last.climbs.last
    assert_equal "5.10a", climb.name
    assert_not climb.sent?
    assert climb.goal?
  end

  test ".new_from_climbs many climbs" do
    tr = Discipline.create!(name: "Indoor Top Rope")
    Climb.create!(grade: "5.7", discipline: tr)
    Climb.create!(grade: "5.8", discipline: tr)
    Climb.create!(grade: "5.7", discipline: tr)
    pyramid = Pyramid.new_from_climbs(tr)
    assert_equal 4, pyramid.pyramid_grades.size

    climb = pyramid.pyramid_grades.first.climbs.first
    assert_equal "5.10a", climb.name
    assert_not climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.second.climbs.first
    assert_equal "5.9", climb.name
    assert_not climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.third.climbs.first
    assert_equal "5.8", climb.name
    assert climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.third.climbs.second
    assert_equal "5.8", climb.name
    assert_not climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.last.climbs.first
    assert_equal "5.7", climb.name
    assert climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.last.climbs.second
    assert_equal "5.7", climb.name
    assert climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.last.climbs.third
    assert_equal "5.7", climb.name
    assert_not climb.sent?
    assert climb.goal?
  end

  # ["5.4", "5.5", "5.6", "5.7", "5.8", "5.9", "5.10a", "5.10b"]
  # [1, 4, 14, 20, 16, 8, 6, 2]
  test ".new_from_climbs more than 8 climbs per grade" do
    1.times { Climb.create!(grade: "5.4") }
    4.times { Climb.create!(grade: "5.5") }
    14.times { Climb.create!(grade: "5.6") }
    20.times { Climb.create!(grade: "5.7") }
    16.times { Climb.create!(grade: "5.8") }
    8.times { Climb.create!(grade: "5.9") }
    6.times { Climb.create!(grade: "5.10a") }
    2.times { Climb.create!(grade: "5.10b") }

    pyramid = Pyramid.new_from_climbs(Discipline.first)

    assert_equal 1, pyramid.pyramid_grades.first.climbs.size
    climb = pyramid.pyramid_grades.first.climbs.first
    assert_equal "5.10d", climb.name
    assert_not climb.sent?

    assert_equal 2, pyramid.pyramid_grades.second.climbs.size
    climb = pyramid.pyramid_grades.second.climbs.first
    assert_equal "5.10c", climb.name
    assert_not climb.sent?

    climb = pyramid.pyramid_grades.second.climbs.second
    assert_equal "5.10c", climb.name
    assert_not climb.sent?

    assert_equal 4, pyramid.pyramid_grades.third.climbs.size
    climb = pyramid.pyramid_grades.third.climbs[1]
    assert_equal "5.10b", climb.name
    assert climb.sent?

    climb = pyramid.pyramid_grades.third.climbs[2]
    assert_equal "5.10b", climb.name
    assert_not climb.sent?

    assert_equal 8, pyramid.pyramid_grades.fourth.climbs.size
    climb = pyramid.pyramid_grades.fourth.climbs[5]
    assert_equal "5.10a", climb.name
    assert climb.sent?

    climb = pyramid.pyramid_grades.fourth.climbs[6]
    assert_equal "5.10a", climb.name
    assert_not climb.sent?
  end
end
