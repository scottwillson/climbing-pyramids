# frozen_string_literal: true

class Person < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true

  has_many :climbs, inverse_of: :person, dependent: :destroy
  has_many :pyramids, inverse_of: :person, dependent: :destroy
end
