class HomeController < ApplicationController
  def index
    @pyramid = Pyramid.new_from_climbs
  end
end
