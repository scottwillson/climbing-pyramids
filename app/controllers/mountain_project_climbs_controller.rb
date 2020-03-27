# frozen_string_literal: true

class MountainProjectClimbsController < ApplicationController
  before_action :authenticate_person!

  def create
    CreateMountainProjectClimbs.new(current_person).call!
    redirect_to climbs_path
  end
end
