# frozen_string_literal: true

require "test_helper"

class MountainProjectClimbTest < ActiveSupport::TestCase
  test ".call" do
    Discipline.seed!
    stub_mountain_project_api
    person = Person.create!(email: "person@example.com", mountain_project_user_id: "112", password: "secret")

    CreateMountainProjectClimbs.new(person).call!

    assert_equal 107, Climb.count
    climb = Climb.find_by(mountain_project_tick_id: 118_051_965)
    assert_equal "2019-11-16", climb.climbed_on.to_s
    assert_equal "Trad", climb.discipline.name
    assert_equal "5.8", climb.grade.name
    assert_equal "108237549", climb.mountain_project_route_id
    assert_equal "Crimson Tide", climb.name

    climb = Climb.find_by(mountain_project_tick_id: 116_663_614)
    assert_equal "2019-03-26", climb.climbed_on.to_s
    assert_equal "Outdoor Boulder", climb.discipline.name
    assert_equal "V0", climb.grade.name
    assert_equal "106400425", climb.mountain_project_route_id
    assert_equal "Velouria", climb.name

    assert_equal 2, Climb.where(mountain_project_route_id: 107_434_220).count
  end
end
