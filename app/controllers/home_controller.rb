class HomeController < ApplicationController
  def index
    @pyramids = [Pyramid.new_from_climbs]
  end
end
