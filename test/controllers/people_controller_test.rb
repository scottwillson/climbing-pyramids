# frozen_string_literal: true

require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "edit" do
    person = Person.create!(email: "person@example.com", password: "secret")
    sign_in person

    get edit_person_path(person)
  end

  test "update" do
    person = Person.create!(email: "person@example.com", password: "secret")
    sign_in person

    patch person_path(
      person,
      params: {
        person: { email: "person-2@example.com", mountain_project_user_id: "1" }
      }
    )

    assert_redirected_to edit_person_path(person)
  end
end
