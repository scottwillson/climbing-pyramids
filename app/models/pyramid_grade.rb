# frozen_string_literal: true

class PyramidGrade
  attr_reader :grade

  def initialize(grade)
    @grade = grade
  end

  delegate :name, to: :grade

  def climbs
    @climbs ||= []
  end
end
