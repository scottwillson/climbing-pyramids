# frozen_string_literal: true

class PyramidClimb
  attr_reader :grade
  attr_accessor :climb
  attr_accessor :goal
  attr_accessor :sent

  def initialize(grade, goal: false, sent: false)
    @goal = goal
    @grade = grade
    @sent = sent
  end

  delegate :name, to: :grade

  def climb_id
    climb&.id
  end

  def climb_name
    climb&.name
  end

  def goal?
    @goal
  end

  def sent?
    @sent
  end
end
