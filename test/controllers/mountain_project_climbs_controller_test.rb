# frozen_string_literal: true

require "test_helper"

class MountainProjectClimbsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "create" do
    sign_in Person.create!(email: "person@example.com", password: "secret", mountain_project_user_id: "1337")
    Discipline.seed!
    stub_mountain_project_api

    post mountain_project_climbs_path

    assert_redirected_to climbs_path
  end
end
