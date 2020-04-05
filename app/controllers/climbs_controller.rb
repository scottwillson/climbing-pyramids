# frozen_string_literal: true

class ClimbsController < ApplicationController
  before_action :authenticate_person!

  def create
    discipline = Discipline.find(climb_params[:discipline_id])
    discipline.climbs.create!(grade: climb_params[:grade])
    Pyramid.find_or_create_by!(discipline: discipline)
    redirect_to root_path
  end

  def destroy
    climb = Climb.find(params[:id])
    climb.destroy!
    redirect_to root_path
  end

  def index
    Discipline.seed! unless Discipline.any?
    @climbs = Climb.includes(:discipline).all
  end

  private

  def climb_params
    params.require(:climb).permit(:discipline_id, :grade)
  end
end
