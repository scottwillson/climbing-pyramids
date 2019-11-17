class PyramidClimb
  attr_reader :name

  def initialize(name, goal: false, sent: false)
    @goal = goal
    @name = name
    @sent = sent
  end

  def goal?
    @goal
  end

  def sent?
    @sent
  end
end
