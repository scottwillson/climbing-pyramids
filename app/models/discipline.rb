# frozen_string_literal: true

class Discipline < ApplicationRecord
  scope :with_climbs, -> { joins(:climbs).uniq }

  has_many :climbs, inverse_of: :discipline, dependent: :restrict_with_error

  def self.seed!
    [
      "Indoor Top Rope",
      "Indoor Lead",
      "Outdoor Top Rope",
      "Outdoor Lead",
      "Outdoor Trad",
      "Indoor Boulder",
      "Outdoor Boulder"
    ].each do |name|
      Discipline.create! name: name
    end
  end

  def self.without_climbs
    all - with_climbs
  end
end
