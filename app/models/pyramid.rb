class Pyramid < ApplicationRecord
  def self.new_from_redpoint(redpoint)
    redpoint_grade = Grade.new_from_string(redpoint)
    pyramid = Pyramid.new
    grades = (redpoint_grade..redpoint_grade.plus(3))
    grades.reverse_each.with_index do |grade, index|
      pyramid_grade = PyramidGrade.new(grade.name)
      (2**index).times do
        pyramid_grade.climbs << PyramidClimb.new(grade.name)
      end
      pyramid.pyramid_grades << pyramid_grade
    end
    pyramid
  end

  def self.new_from_climbs
    redpoint_grade = Climb.first&.grade || Grade.new_from_string("5.6")
    new_from_redpoint(redpoint_grade)
  end

  def pyramid_grades
    @pyramid_grades ||= []
  end
end
