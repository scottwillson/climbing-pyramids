# frozen_string_literal: true

require "test_helper"

class DisciplineTest < ActiveSupport::TestCase
  test "#with_climbs" do
    person = Person.create!(email: "person@example.com", password: "secret123!")
    assert Discipline.with_climbs(person).empty?

    tr = Discipline.create!(name: "Indoor Top Rope")
    person.climbs.create!(grade: "5.7", discipline: tr)
    assert_equal 1, Discipline.with_climbs(person).size

    discipline = Discipline.create!(name: "Outdoor Top Rope")
    person.climbs.create!(grade: "5.8", discipline: tr)
    person.climbs.create!(grade: "5.7", discipline: discipline)
    assert_equal 2, Discipline.with_climbs(person).size

    anpther_person = Person.create!(email: "person_two@example.com", password: "secret123!")
    assert_equal 0, Discipline.with_climbs(anpther_person).size
  end

  test "#without_climbs" do
    person = Person.create!(email: "person@example.com", password: "secret123!")
    assert Discipline.without_climbs(person).empty?

    tr = Discipline.create!(name: "Indoor Top Rope")
    outdoor_tr = Discipline.create!(name: "Outdoor Top Rope")
    assert_equal 2, Discipline.without_climbs(person).size

    person.climbs.create!(grade: "5.8", discipline: tr)
    assert_equal 1, Discipline.without_climbs(person).size

    person.climbs.create!(grade: "5.8", discipline: outdoor_tr)
    assert Discipline.without_climbs(person).empty?
  end
end
