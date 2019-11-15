class Pyramid < ApplicationRecord
  def grades
    @grades ||= [
      Grade.new("5.11c"),
      Grade.new("5.11b"),
      Grade.new("5.11a"),
      Grade.new("5.10d")
    ]
  end
end
