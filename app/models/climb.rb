# frozen_string_literal: true

class Climb < ApplicationRecord
  belongs_to :discipline

  validates :discipline, presence: true

  default_value_for :discipline do
    Discipline.find_or_create_by(name: "Outdoor Lead")
  end

  def grade
    @grade ||= Grade.new(decimal: grade_decimal, letter: grade_letter)
  end

  def grade=(grade)
    @grade = case grade
             when Grade
               grade
             else
               Grade.new_from_string(grade.to_s)
             end

    self.grade_decimal = @grade.decimal
    self.grade_letter = @grade.letter
  end
end
