require "test_helper"

class PyramidControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "edit" do
    person = Person.create!(email: "person@example.com", password: "secret")
    sign_in person

    pyramid = person.pyramids.create!
    get edit_pyramid_path(pyramid)
  end

  test "update" do
    person = Person.create!(email: "person@example.com", password: "secret")
    sign_in person

    pyramid = person.pyramids.create!
    patch pyramid_path(pyramid, params: { id: pyramid.id, pyramid: { redpoint_grade: "5.12c" } })
  end
end
