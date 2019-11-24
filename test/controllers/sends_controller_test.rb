require "test_helper"

class SendsControllerTest < ActionDispatch::IntegrationTest
  test "create" do
    post sends_path(params: { send: { decimal: "7", letter: "" } })
    assert_redirected_to root_path
    assert_equal 1, Climb.count
    grade = Climb.first.grade
    assert_equal 7, grade.decimal
    assert_equal "", grade.letter
  end

  test "create 5.11c" do
    post sends_path(params: { send: { decimal: "11", letter: "c" } })
    assert_redirected_to root_path
    assert_equal 1, Climb.count
    grade = Climb.first.grade
    assert_equal 11, grade.decimal
    assert_equal "c", grade.letter
  end

  test "destroy" do
    climb = Climb.create!(grade_decimal: 6)
    delete send_path(climb.id)
    assert_redirected_to root_path
    assert_equal 0, Climb.count
  end
end
