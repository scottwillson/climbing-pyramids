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
    climb = Climb.new(grade:)
    assert_equal 11, climb.grade_decimal
    assert_equal "a", climb.grade_letter
    assert_equal Grade.new(decimal: 11, letter: "a"), climb.grade
  end

  test "discipline default " do
    person = Person.create!(email: "person@example.com", password: "secret123!")
    person.climbs.create!(grade: "5.8")
    assert_equal ["Outdoor Lead"], Discipline.pluck(:name)
  end

  test "discipline default override" do
    person = Person.create!(email: "person@example.com", password: "secret123!")
    tr = Discipline.create!(name: "Indoor Top Rope")
    person.climbs.create!(grade: "5.8", discipline: tr)
    assert_equal ["Indoor Top Rope"], Discipline.pluck(:name)
  end
end
