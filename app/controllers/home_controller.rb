# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_person!

  def index
    Discipline.seed! unless Discipline.any?

    @disciplines_with_climbs = Discipline.with_climbs(current_person)
    @disciplines_without_climbs = Discipline.without_climbs(current_person)
    @pyramids = current_person.pyramids.each(&:create_grades).each(&:mark_sends)
  end
end
