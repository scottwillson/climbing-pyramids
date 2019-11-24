class PyramidClimb
  attr_reader :grade
  attr_accessor :climb_id
  attr_accessor :goal
  attr_accessor :sent

  def initialize(grade, goal: false, sent: false)
    @goal = goal
    @grade = grade
    @sent = sent
  end

  def name
    grade.name
  end

  def goal?
    @goal
  end

  def sent?
    @sent
  end
end
