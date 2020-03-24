# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_person!

  def index
    @pyramids = Pyramid.all_for_disciplines
  end
end
