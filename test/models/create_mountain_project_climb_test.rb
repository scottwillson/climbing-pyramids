# frozen_string_literal: true

require "test_helper"

class MountainProjectClimbTest < ActiveSupport::TestCase
  test ".call" do
    Discipline.seed!
    stub_mountain_project_api
    person = Person.create!(email: "person@example.com", mountain_project_user_id: "112", password: "secret")

    CreateMountainProjectClimbs.new(person).call!

    assert_equal 119, Climb.count
  end
end
