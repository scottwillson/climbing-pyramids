class HomeController < ApplicationController
  def index
    @pyramid = Pyramid.new_from_redpoint("5.10d")
  end
end
