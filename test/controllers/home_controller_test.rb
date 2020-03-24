# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "index" do
    get root_path
    assert_redirected_to new_person_registration_path
  end

  test "index signed in" do
    sign_in Person.create!(email: "person@example.com", password: "secret")
    get root_path
    assert_response :success
  end
end
