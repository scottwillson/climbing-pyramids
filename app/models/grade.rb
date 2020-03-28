# frozen_string_literal: true

# decimal .4, .13
# letter a-d
# plus: 5.10a + 2 = 5.12c
#
# boundaries: 5.0 .. 5.16d
#             5.9 .. 5.10a
#             5.11a .. 5.11d
class Grade
  include Comparable

  attr_reader :decimal
  attr_reader :letter

  def self.all
    Grade.new(decimal: "4")..Grade.new(decimal: "15", letter: "d")
  end

  def self.decimal_from_string(string)
    matches = string.match(/5\.(\d{1,2})([a-d]{0,1})/)
    matches[1].to_i
  end

  def self.letter_from_string(string)
    matches = string.match(/5\.(\d{1,2})([a-d]{0,1})/)
    matches[2] || ""
  end

  def self.new_from_string(string)
    return string if string.is_a?(Grade)

    decimal = decimal_from_string(string)
    letter = letter_from_string(string)
    Grade.new(decimal: decimal, letter: letter)
  end

  def initialize(decimal:, letter: "")
    @decimal = decimal.to_i
    @letter = letter
  end

  def name
    "5.#{decimal}#{letter}"
  end

  def plus(letter_grades)
    grade = dup
    letter_grades.times do
      grade = grade.succ
    end
    grade
  end

  def succ
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
