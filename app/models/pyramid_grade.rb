class PyramidGrade
  attr_reader :grade

  def initialize(grade)
    @grade = grade
  end

  def name
    grade.name
  end

  def climbs
    @climbs ||= []
  end
end
