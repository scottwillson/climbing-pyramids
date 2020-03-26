# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_person!

  def index
    Discipline.seed! unless Discipline.any?

    @disciplines_with_climbs = Discipline.with_climbs
    @disciplines_without_climbs = Discipline.without_climbs
    @pyramids = Pyramid.all_with_climbs(@disciplines_with_climbs)
  end
end
