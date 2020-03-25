# frozen_string_literal: true

class Discipline < ApplicationRecord
  scope :with_climbs, -> { joins(:climbs).uniq }

  has_many :climbs, inverse_of: :discipline, dependent: :restrict_with_error

  def self.without_climbs
    all - with_climbs
  end
end
