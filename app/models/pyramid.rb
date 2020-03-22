class Pyramid < ApplicationRecord
  belongs_to :discipline

  validates :discipline, presence: true

  default_value_for :discipline do
    Discipline.find_or_create_by(name: "Outdoor Lead")
  end

  def self.all_for_disciplines
    Discipline.all.map do |discipline|
      new_from_climbs(discipline)
    end
  end

  def self.new_from_redpoint(redpoint, discipline)
    redpoint_grade = Grade.new_from_string(redpoint)
    pyramid = Pyramid.new(discipline: discipline)
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

  def self.new_from_climbs(discipline)
    redpoint_grade = Climb.find_by(discipline: discipline)&.grade || Grade.new_from_string("5.6")
    new_from_redpoint(redpoint_grade, discipline).mark_sends!(discipline)
  end

  def pyramid_grades
    @pyramid_grades ||= []
  end

  def mark_sends!(discipline)
    # Not efficient with large number of climbs. Could be constrained.
    Climb.where(discipline: discipline).order(:created_at).each do |climb|
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
