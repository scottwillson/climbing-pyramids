# frozen_string_literal: true

require "test_helper"

class SendsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "create" do
    sign_in Person.create!(email: "person@example.com", password: "secret")
    discipline = Discipline.create!(name: "TR")

    post discipline_sends_path(discipline, params: { send: { decimal: "7", letter: "" } })

    assert_redirected_to root_path
    assert_equal 1, Climb.count
    grade = Climb.first.grade
    assert_equal 7, grade.decimal
    assert_equal "", grade.letter
  end

  test "create 5.11c" do
    sign_in Person.create!(email: "person@example.com", password: "secret")

    post sends_path(params: { send: { decimal: "11", letter: "c" } })

    assert_redirected_to root_path
    assert_equal 1, Climb.count
    grade = Climb.first.grade
    assert_equal 11, grade.decimal
    assert_equal "c", grade.letter
  end

  test "destroy" do
    sign_in Person.create!(email: "person@example.com", password: "secret")
    climb = Climb.create!(grade_decimal: 6, discipline: Discipline.create!(name: "TR"))

    delete send_path(climb.id)

    assert_redirected_to root_path
    assert_equal 0, Climb.count
  end
end
