# frozen_string_literal: true

require "test_helper"

class PyramidTest < ActiveSupport::TestCase
  test "attributes" do
    pyramid = Pyramid.new
    assert_equal 0, pyramid.pyramid_grades.size
  end

  test ".new from redpoint" do
    person = Person.create!(email: "person@example.com", password: "secret")
    pyramid = person.pyramids.build(redpoint_grade: "5.11c")
    pyramid.create_grades
    assert_equal 4, pyramid.pyramid_grades.size
    assert_equal ["5.12b"], pyramid.pyramid_grades.first.climbs.map(&:name)
    assert_equal ["5.12a", "5.12a"], pyramid.pyramid_grades.second.climbs.map(&:name)
    assert_equal ["5.11d", "5.11d", "5.11d", "5.11d"], pyramid.pyramid_grades.third.climbs.map(&:name)
    assert_equal ["5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c", "5.11c"], pyramid.pyramid_grades.fourth.climbs.map(&:name)
  end

  test ".new no climbs" do
    person = Person.create!(email: "person@example.com", password: "secret")
    pyramid = person.pyramids.build
    pyramid.create_grades
    assert_equal 4, pyramid.pyramid_grades.size
    assert_equal ["5.9"], pyramid.pyramid_grades.first.climbs.map(&:name)
  end

  test ".new from climb" do
    person = Person.create!(email: "person@example.com", password: "secret")
    tr = Discipline.create!(name: "Indoor Top Rope")
    person.climbs.create!(grade: "5.10a", discipline: tr)
    pyramid = person.pyramids.build(discipline: tr)
    pyramid.create_grades
    pyramid.mark_sends
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

  test ".new from many climbs" do
    tr = Discipline.create!(name: "Indoor Top Rope")
    person = Person.create!(email: "person@example.com", password: "secret123")
    person.climbs.create!(grade: "5.7", discipline: tr)
    person.climbs.create!(grade: "5.8", discipline: tr)
    person.climbs.create!(grade: "5.7", discipline: tr)
    pyramid = person.pyramids.create!(discipline: tr)
    pyramid.create_grades
    pyramid.mark_sends
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

  test ".new from many bouldering climbs" do
    tr = Discipline.create!(name: "Outdoor Bouldering")
    person = Person.create!(email: "person@example.com", password: "secret123")
    person.climbs.create!(grade: "V2", discipline: tr)
    person.climbs.create!(grade: "V3", discipline: tr)
    person.climbs.create!(grade: "V2", discipline: tr)
    pyramid = person.pyramids.create!(discipline: tr)
    pyramid.create_grades
    pyramid.mark_sends
    assert_equal 4, pyramid.pyramid_grades.size

    climb = pyramid.pyramid_grades.first.climbs.first
    assert_equal "V5", climb.name
    assert_not climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.second.climbs.first
    assert_equal "V4", climb.name
    assert_not climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.third.climbs.first
    assert_equal "V3", climb.name
    assert climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.third.climbs.second
    assert_equal "V3", climb.name
    assert_not climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.last.climbs.first
    assert_equal "V2", climb.name
    assert climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.last.climbs.second
    assert_equal "V2", climb.name
    assert climb.sent?
    assert climb.goal?

    climb = pyramid.pyramid_grades.last.climbs.third
    assert_equal "V2", climb.name
    assert_not climb.sent?
    assert climb.goal?
  end

  test ".new from more than 8 climbs per grade" do
    person = Person.create!(email: "person@example.com", password: "secret")
    1.times { person.climbs.create!(grade: "5.4") }
    2.times { person.climbs.create!(grade: "5.5") }
    10.times { person.climbs.create!(grade: "5.6") }
    18.times { person.climbs.create!(grade: "5.7") }
    14.times { person.climbs.create!(grade: "5.8") }
    8.times { person.climbs.create!(grade: "5.9") }
    2.times { person.climbs.create!(grade: "5.10a") }

    pyramid = person.pyramids.create!(discipline: Discipline.first)
    pyramid.create_grades
    pyramid.mark_sends

    assert_equal 1, pyramid.pyramid_grades.first.climbs.size
    climb = pyramid.pyramid_grades.first.climbs.first
    assert_equal "5.10b", climb.name
    assert_not climb.sent?

    assert_equal 2, pyramid.pyramid_grades.second.climbs.size
    climb = pyramid.pyramid_grades.second.climbs.first
    assert_equal "5.10a", climb.name
    assert climb.sent?

    climb = pyramid.pyramid_grades.second.climbs.second
    assert_equal "5.10a", climb.name
    assert climb.sent?

    assert_equal 4, pyramid.pyramid_grades.third.climbs.size
    climb = pyramid.pyramid_grades.third.climbs.first
    assert_equal "5.9", climb.name
    assert climb.sent?

    climb = pyramid.pyramid_grades.third.climbs.last
    assert_equal "5.9", climb.name
    assert climb.sent?

    assert_equal 8, pyramid.pyramid_grades.fourth.climbs.size
    climb = pyramid.pyramid_grades.fourth.climbs.first
    assert_equal "5.8", climb.name
    assert climb.sent?

    climb = pyramid.pyramid_grades.fourth.climbs.last
    assert_equal "5.8", climb.name
    assert climb.sent?
  end

  test ".new_from_climbs climbs + redpoint" do
    person = Person.create!(email: "person@example.com", password: "secret")
    2.times { person.climbs.create!(grade: "5.4") }
    1.times { person.climbs.create!(grade: "5.5") }
    6.times { person.climbs.create!(grade: "5.6") }
    6.times { person.climbs.create!(grade: "5.7") }
    3.times { person.climbs.create!(grade: "5.8") }

    pyramid = person.pyramids.create!(discipline: Discipline.first, redpoint_grade: "5.7")
    pyramid.create_grades
    pyramid.mark_sends
    climb = pyramid.pyramid_grades.first.climbs.first
    assert_equal "5.10a", climb.name
    assert_not climb.sent?
  end
end
