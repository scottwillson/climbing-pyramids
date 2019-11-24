class Pyramid < ApplicationRecord
  def self.new_from_redpoint(redpoint)
    redpoint_grade = Grade.new_from_string(redpoint)
    pyramid = Pyramid.new
    grades = (redpoint_grade..redpoint_grade.plus(3))
    grades.reverse_each.with_index do |grade, index|
      pyramid_grade = PyramidGrade.new(grade)
      (2**index).times do
        pyramid_grade.climbs << PyramidClimb.new(grade, goal: true)
      end
      pyramid.pyramid_grades << pyramid_grade
    end
    pyramid
  end

  def self.new_from_climbs
    redpoint_grade = Climb.first&.grade || Grade.new_from_string("5.6")
    new_from_redpoint(redpoint_grade).mark_sends!
  end

  def pyramid_grades
    @pyramid_grades ||= []
  end

  def mark_sends!
    # Not efficient with large number of climbs. Could be constrained.
    Climb.order(:created_at).each do |climb|
      sent_grade = climb.grade
      pyramid_grade = pyramid_grades.detect { |g| g.grade == sent_grade }
      next unless pyramid_grade

      pyramid_climb = pyramid_grade.climbs.detect { |c| c.grade == sent_grade && !c.sent? }
      next unless pyramid_climb

      pyramid_climb.sent = true
      pyramid_climb.climb_id = climb.id
    end
    self
  end
end
