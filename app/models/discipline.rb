# frozen_string_literal: true

class Discipline < ApplicationRecord
  has_many :climbs, inverse_of: :discipline, dependent: :restrict_with_error

  def self.seed!
    [
      "Indoor Boulder",
      "Indoor Lead",
      "Indoor Top Rope",
      "Outdoor Boulder",
      "Outdoor Lead",
      "Outdoor Top Rope",
      "Trad"
    ].each do |name|
      Discipline.create! name:
    end
  end

  def self.with_climbs(person)
    Discipline.find(person.climbs.pluck(:discipline_id).uniq)
  end

  def self.without_climbs(person)
    all - with_climbs(person)
  end

  def boulder?
    name == "Indoor Boulder" || name == "Outdoor Boulder"
  end
end
