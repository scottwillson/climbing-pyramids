# frozen_string_literal: true

class Discipline < ApplicationRecord
  scope :with_climbs, ->(person) { joins(:climbs).uniq }

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
      Discipline.create! name: name
    end
  end

  def self.without_climbs(person)
    all - with_climbs(person)
  end
end
