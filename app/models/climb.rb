# frozen_string_literal: true

class Climb < ApplicationRecord
  attribute :climbed_on, :date, default: -> { Time.zone.today }

  belongs_to :discipline,
             default: -> { Discipline.find_or_create_by(name: "Outdoor Lead") },
             inverse_of: :climbs

  belongs_to :person, inverse_of: :climbs

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
