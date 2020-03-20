class HomeController < ApplicationController
  def index
    @pyramids = Pyramid.all_for_disciplines
  end
end
