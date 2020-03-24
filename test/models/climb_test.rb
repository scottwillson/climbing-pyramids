# frozen_string_literal: true

require "test_helper"

class ClimbTest < ActiveSupport::TestCase
  test ".grade=(String)" do
    climb = Climb.new(grade: "5.11a")
    assert_equal 11, climb.grade_decimal
    assert_equal "a", climb.grade_letter
    assert_equal Grade.new(decimal: 11, letter: "a"), climb.grade
  end

  test ".grade=(Grade)" do
    grade = Grade.new(decimal: 11, letter: "a")
    climb = Climb.new(grade: grade)
    assert_equal 11, climb.grade_decimal
    assert_equal "a", climb.grade_letter
    assert_equal Grade.new(decimal: 11, letter: "a"), climb.grade
  end
end
