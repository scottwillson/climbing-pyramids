# frozen_string_literal: true

require "test_helper"

class GradeTest < ActiveSupport::TestCase
  test ".decimal_from_string" do
    assert_equal 8, Grade.decimal_from_string("5.8")
    assert_equal 12, Grade.decimal_from_string("5.12a")
  end

  test ".letter_from_string" do
    assert_equal "", Grade.letter_from_string("5.8")
    assert_equal "c", Grade.letter_from_string("5.11c")
  end

  test ".new_from_string" do
    grade = Grade.new_from_string("5.12a")
    assert_equal "5.12a", grade.name
  end

  test ".new_from_string bouldering" do
    grade = Grade.new_from_string("V0")
    assert_equal "V0", grade.name
    assert_equal 0, grade.decimal
    assert_equal "V", grade.letter

    assert_equal "V0", Grade.new_from_string("V0-").name
    assert_equal "V2", Grade.new_from_string("V2").name
    assert_equal "V2", Grade.new_from_string("V2+").name

    grade = Grade.new_from_string("VB")
    assert_equal(-1, grade.decimal)
    assert_equal "V", grade.letter
    assert_equal "VB", grade.name
  end

  test "#==" do
    assert_equal Grade.new(decimal: 9), Grade.new(decimal: 9)
    assert_not_equal Grade.new(decimal: 8), Grade.new(decimal: 9)
    assert_not_equal nil, Grade.new(decimal: 9)
    assert_not_equal Grade.new(decimal: 9), nil
    assert_not_equal 9, Grade.new(decimal: 9)
    assert_not_equal Grade.new(decimal: 9), 9
    assert_not_equal "9", Grade.new(decimal: 9)
    assert_not_equal Grade.new(decimal: 9), "9"
    assert_equal Grade.new(decimal: 10, letter: "b"), Grade.new(decimal: 10, letter: "b")
    assert_not_equal Grade.new(decimal: 10, letter: "d"), Grade.new(decimal: 10, letter: "b")
    assert_not_equal Grade.new(decimal: 10, letter: "b"), Grade.new(decimal: 11, letter: "b")
    assert_not_equal Grade.new(decimal: 4), Grade.new(decimal: 11, letter: "b")
  end

  test "#<=>" do
    assert_equal(0, Grade.new(decimal: 9) <=> Grade.new(decimal: 9)) # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
    assert_equal(-1, Grade.new(decimal: 8) <=> Grade.new(decimal: 9))
    assert_equal(0, Grade.new(decimal: 10, letter: "b") <=> Grade.new(decimal: 10, letter: "b")) # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
    assert_equal(1, Grade.new(decimal: 10, letter: "d") <=> Grade.new(decimal: 10, letter: "b"))
    assert_equal(-1, Grade.new(decimal: 10, letter: "b") <=> Grade.new(decimal: 11, letter: "b"))
    assert_equal(-1, Grade.new(decimal: 4) <=> Grade.new(decimal: 11, letter: "b"))
    assert_nil(nil <=> Grade.new(decimal: 9))
    assert_equal(-1, Grade.new(decimal: 9) <=> nil)
    assert_nil(9 <=> Grade.new(decimal: 9))
    assert_equal(-1, Grade.new(decimal: 9) <=> 9)
    assert_equal(1, "9" <=> Grade.new(decimal: 9))
    assert_equal(-1, Grade.new(decimal: 9) <=> "9")
  end
  test "#plus" do
    grade = Grade.new_from_string("5.6").plus(1)
    assert_equal "5.7", grade.name

    grade = Grade.new_from_string("V7").plus(1)
    assert_equal "V8", grade.name

    grade = Grade.new_from_string("VB").plus(1)
    assert_equal "V0", grade.name
  end

  test "#succ" do
    assert_equal Grade.new_from_string("5.7"), Grade.new_from_string("5.6").succ
    assert_equal Grade.new_from_string("5.1"), Grade.new_from_string("5.0").succ
    assert_equal Grade.new_from_string("5.10a"), Grade.new_from_string("5.9").succ
    assert_equal Grade.new_from_string("5.10c"), Grade.new_from_string("5.10b").succ
    assert_equal Grade.new_from_string("5.11a"), Grade.new_from_string("5.10d").succ

    assert_equal Grade.new_from_string("V1"), Grade.new_from_string("V0").succ
    assert_equal Grade.new_from_string("V13"), Grade.new_from_string("V12").succ
    assert_equal Grade.new_from_string("V0"), Grade.new_from_string("VB").succ
  end
end
