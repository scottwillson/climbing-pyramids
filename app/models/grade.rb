# frozen_string_literal: true

# decimal .4, .13, B, 1, 12
# letter a-d, V
# plus: 5.10a + 2 = 5.12c, V3 + 3 = V6
#
# boundaries: 5.0 .. 5.16d
#             5.9 .. 5.10a
#             5.11a .. 5.11d
#             VB .. V16
class Grade
  BOULDER_REGEX = /V(\d{0,2}B{0,1})/.freeze
  ROUTE_REGEX = /5\.(\d{1,2})([a-d]{0,1})/.freeze

  include Comparable

  attr_reader :decimal
  attr_reader :letter

  def self.all(discipline = nil)
    if discipline&.boulder?
      boulder_grades
    elsif discipline
      route_grades
    else
      route_grades.to_a + boulder_grades.to_a
    end
  end

  def self.boulder_grades
    Grade.new(letter: "V", decimal: "-1")..Grade.new(decimal: "16", letter: "V")
  end

  def self.decimal_from_string(string)
    matches = string.match(ROUTE_REGEX)
    return matches[1].to_i if matches

    matches = string.match(BOULDER_REGEX)
    decimal = matches[1]
    return -1 if decimal == "B"

    decimal
  end

  def self.first
    all.first
  end

  def self.letter_from_string(string)
    return "V" if string[/^V/]
    matches = string.match(/5\.(\d{1,2})([a-d]{0,1})/)
    matches[2] || ""
  end

  def self.new_from_string(string)
    return string if string.is_a?(Grade)

    decimal = decimal_from_string(string)
    letter = letter_from_string(string)
    Grade.new(decimal: decimal, letter: letter)
  end

  def self.route_grades
    Grade.new(decimal: "4")..Grade.new(decimal: "15", letter: "d")
  end

  def initialize(decimal:, letter: "")
    @decimal = decimal.to_i
    @letter = letter
  end

  def boulder?
    letter == "V"
  end

  def name
    if boulder?
      if decimal == -1
        "VB"
      else
        "V#{decimal}"
      end
    else
      "5.#{decimal}#{letter}"
    end
  end

  def plus(grades)
    grade = dup
    grades.times do
      grade = grade.succ
    end
    grade
  end

  def succ
    if boulder?
      return Grade.new(decimal: decimal + 1, letter: "V")
    end

    case decimal
    when 0..8
      Grade.new(decimal: decimal + 1)
    when 9
      Grade.new(decimal: 10, letter: "a")
    else
      case letter
      when "a"
        Grade.new(decimal: decimal, letter: "b")
      when "b"
        Grade.new(decimal: decimal, letter: "c")
      when "c"
        Grade.new(decimal: decimal, letter: "d")
      when "d"
        Grade.new(decimal: decimal + 1, letter: "a")
      end
    end
  end

  def to_param
    name
  end

  def to_s
    "#<Grade 5.#{decimal}#{letter}>"
  end

  def hash
    name.hash
  end

  def eql?(other)
    self == other
  end

  def ==(other)
    other.is_a?(Grade) && other.decimal == decimal && other.letter == letter
  end

  def <=>(other)
    return -1 unless other.is_a?(Grade)

    decimal_diff = decimal <=> other.decimal
    return decimal_diff unless decimal_diff == 0

    letter <=> other.letter
  end
end
