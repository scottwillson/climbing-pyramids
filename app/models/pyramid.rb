class Pyramid < ApplicationRecord
  def self.new_from_redpoint(redpoint)
    redpoint_grade = Grade.new_from_string(redpoint)
    pyramid = Pyramid.new
    grades = (redpoint_grade..redpoint_grade.plus(3))
    grades.reverse_each.with_index do |grade, index|
      pyramid_grade = PyramidGrade.new(grade.name)
      (2**index).times do
        pyramid_grade.climbs << PyramidClimb.new(grade)
      end
      pyramid.pyramid_grades << pyramid_grade
    end
    pyramid.mark_sends!
  end

  def self.new_from_climbs
    redpoint_grade = Climb.first&.grade || Grade.new_from_string("5.6")
    new_from_redpoint(redpoint_grade).mark_sends!
  end

  def pyramid_grades
    @pyramid_grades ||= []
  end

  def mark_sends!
    sent_grades = Climb.all.map(&:grade)
    pyramid_grades.each do |pyramid_grade|
      pyramid_grade.climbs.each do |pyramid_climb|
        pyramid_climb.goal = true
        if pyramid_climb.grade.in?(sent_grades)
          pyramid_climb.sent = true
          sent_grades.pop
        end
      end
    end
    self
  end
end
