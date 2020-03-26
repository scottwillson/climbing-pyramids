# frozen_string_literal: true

require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "edit" do
    person = Person.create!(email: "person@example.com", password: "secret")
    sign_in person

    get edit_person_path(person)
  end
end
