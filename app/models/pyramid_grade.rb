class PyramidGrade
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def climbs
    @climbs ||= []
  end
end
