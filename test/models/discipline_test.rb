# frozen_string_literal: true

require "test_helper"

class DisciplineTest < ActiveSupport::TestCase
  test "#with_climbs" do
    assert Discipline.with_climbs.empty?

    tr = Discipline.create!(name: "Indoor Top Rope")
    Climb.create!(grade: "5.7", discipline: tr)
    assert_equal 1, Discipline.with_climbs.size

    discipline = Discipline.create!(name: "Outdoor Top Rope")
    Climb.create!(grade: "5.8", discipline: tr)
    Climb.create!(grade: "5.7", discipline: discipline)
    assert_equal 2, Discipline.with_climbs.size
  end

  test "#without_climbs" do
    assert Discipline.without_climbs.empty?

    tr = Discipline.create!(name: "Indoor Top Rope")
    outdoor_tr = Discipline.create!(name: "Outdoor Top Rope")
    assert_equal 2, Discipline.without_climbs.size

    Climb.create!(grade: "5.8", discipline: tr)
    assert_equal 1, Discipline.without_climbs.size

    Climb.create!(grade: "5.8", discipline: outdoor_tr)
    assert Discipline.without_climbs.empty?
  end
end
