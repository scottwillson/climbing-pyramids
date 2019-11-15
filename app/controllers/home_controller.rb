class HomeController < ApplicationController
  def index
    @pyramid = Pyramid.new
  end
end
