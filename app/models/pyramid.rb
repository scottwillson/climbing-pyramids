# frozen_string_literal: true

class Pyramid < ApplicationRecord
  attribute :discipline_id, :integer, default: -> { Discipline.find_or_create_by(name: "Outdoor Lead").id }

  delegate :name, to: :discipline

  belongs_to :discipline
  has_many :climbs, through: :discipline

  scope :with_climbs, -> { joins(:climbs).uniq }

  validates :discipline, presence: true

  def climbs_above_redpoint
    return climbs unless redpoint_grade

    climbs.reject { |climb| climb.grade < redpoint_grade }
  end

  def complete_grades(climbs_by_grade)
    complete_grades = []

    Grade.all.each_cons(4) do |grades|
      if climbs_by_grade[grades[0]].present? && climbs_by_grade[grades[0]].size >= 8 &&
         climbs_by_grade[grades[1]].present? && climbs_by_grade[grades[1]].size >= 4 &&
         climbs_by_grade[grades[2]].present? && climbs_by_grade[grades[2]].size >= 2 &&
         climbs_by_grade[grades[3]].present? && climbs_by_grade[grades[3]].size >= 1

        complete_grades << grades[0]
      end
    end

    complete_grades
  end

  def create_grades
    climbs_by_grade = climbs_above_redpoint.group_by(&:grade)
    complete_grades = complete_grades(climbs_by_grade)

    if complete_grades.any?
      max_complete_grade = complete_grades.max
      grade_begin = max_complete_grade.succ
    else
      min_climbed_grade = climbs_by_grade.keys.min || redpoint_grade || Grade.new(decimal: "6")
      grade_begin = min_climbed_grade
    end

    grades = (grade_begin..grade_begin.plus(3))
    grades.reverse_each.with_index do |grade, index|
      pyramid_grade = PyramidGrade.new(grade)
      (2**index).times do
        pyramid_grade.climbs << PyramidClimb.new(grade, goal: true)
      end
      pyramid_grades << pyramid_grade
    end
    self
  end

  def mark_sends
    climbs.order(:created_at).each do |climb|
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

  def pyramid_grades
    @pyramid_grades ||= []
  end

  def redpoint_grade
    return @redpoint_grade if @redpoint_grade

    if redpoint_grade_decimal
      @redpoint_grade = Grade.new(decimal: redpoint_grade_decimal, letter: redpoint_grade_letter)
    end
  end

  def redpoint_grade=(grade)
    @redpoint_grade = case grade
                      when Grade
                        grade
                      else
                        Grade.new_from_string(grade.to_s)
                      end

    self.redpoint_grade_decimal = @redpoint_grade.decimal
    self.redpoint_grade_letter = @redpoint_grade.letter
  end
end
