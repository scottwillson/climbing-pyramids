class Grade
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def climbs
    @climbs ||= [Climb.new(name)]
  end
end
