# frozen_string_literal: true

require "test_helper"

class ClimbsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "create" do
    sign_in Person.create!(email: "person@example.com", password: "secret")
    discipline = Discipline.create!(name: "TR")

    post climbs_path(params: { climb: { discipline_id: discipline, grade: "5.7" } })

    assert_redirected_to root_path
    assert_equal 1, Climb.count
    grade = Climb.first.grade
    assert_equal 7, grade.decimal
    assert_equal "", grade.letter
  end

  test "create 5.11c" do
    sign_in Person.create!(email: "person@example.com", password: "secret")
    discipline = Discipline.create!(name: "TR")

    post climbs_path(discipline, params: { climb: { discipline_id: discipline, grade: "5.11c" } })

    assert_redirected_to root_path
    assert_equal 1, Climb.count
    grade = Climb.first.grade
    assert_equal 11, grade.decimal
    assert_equal "c", grade.letter
  end

  test "destroy" do
    sign_in Person.create!(email: "person@example.com", password: "secret")
    discipline = Discipline.create!(name: "TR")
    climb = Climb.create!(grade_decimal: 6, discipline: discipline)

    delete climb_path(climb.id)

    assert_redirected_to root_path
    assert_equal 0, Climb.count
  end

  test "index" do
    sign_in Person.create!(email: "person@example.com", password: "secret")
    Discipline.create!(name: "TR")
    get climbs_path
  end
end