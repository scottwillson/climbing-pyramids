class Climb < ApplicationRecord
  def grade
    @grade ||= Grade.new(decimal: grade_decimal, letter: grade_letter)
  end

  def grade=(grade)
    case grade
    when Grade
      @grade = grade
    else
      @grade = Grade.new_from_string(grade.to_s)
    end

    self.grade_decimal = @grade.decimal
    self.grade_letter = @grade.letter
  end
end
