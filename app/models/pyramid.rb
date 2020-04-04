# frozen_string_literal: true

class Pyramid < ApplicationRecord
  attribute :discipline_id, :integer, default: -> { Discipline.find_or_create_by(name: "Outdoor Lead").id }

  belongs_to :discipline

  validates :discipline, presence: true

  def self.all_with_climbs(disciplines)
    disciplines.map do |discipline|
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
    climbs = Climb.where(discipline: discipline).group_by(&:grade)

    complete_grades = []
    Grade.all.each_cons(4) do |grades|
      if climbs[grades[0]].present? && climbs[grades[0]].size >= 8 &&
        climbs[grades[1]].present? && climbs[grades[1]].size >= 4 &&
        climbs[grades[2]].present? && climbs[grades[2]].size >= 2 &&
        climbs[grades[3]].present? && climbs[grades[3]].size >= 1

        complete_grades << grades[0]
      end
    end

    pyramid = nil
    if complete_grades.any?
      max_complete_grade = complete_grades.max
      pyramid = new_from_redpoint(max_complete_grade.succ, discipline)
    else
      min_climbed_grade = climbs.keys.min || Grade.new(decimal: "6")
      pyramid = new_from_redpoint(min_climbed_grade, discipline)
    end

    pyramid.mark_climbs! discipline
  end

  def pyramid_grades
    @pyramid_grades ||= []
  end

  def mark_climbs!(discipline)
    # Not efficient with large number of climbs. Could be constrained.
    Climb.where(discipline: discipline).order(:created_at).each do |climb|
      sent_grade = climb.grade
      pyramid_grade = pyramid_grades.detect { |g| g.grade == sent_grade }
      next unless pyramid_grade

      pyramid_climb = pyramid_grade.climbs.detect { |c| c.grade == sent_grade && !c.sent? }
      next unless pyramid_climb

      pyramid_climb.sent = true
      pyramid_climb.climb = climb
    end
    self
  end
end
