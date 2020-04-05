# frozen_string_literal: true

class ClimbsController < ApplicationController
  before_action :authenticate_person!

  def create
    discipline = Discipline.find(climb_params[:discipline_id])
    discipline.climbs.create!(grade: climb_params[:grade], person: current_person)
    Pyramid.find_or_create_by!(discipline: discipline, person: current_person)
    redirect_to root_path
  end

  def destroy
    climb = Climb.find(params[:id])
    raise("Not your climb") unless climb.person == current_person

    climb.destroy!
    redirect_to root_path
  end

  def edit
    @climb = Climb.find(params[:id])
    raise("Not your climb") unless climb.person == current_person
  end

  def index
    Discipline.seed! unless Discipline.any?
    @climbs = Climb.includes(:discipline).where(person: current_person).all
  end

  def update
    @climb = Climb.find(params[:id])
    raise("Not your climb") unless climb.person == current_person

    if @climb.update(climb_params)
      return redirect_to(edit_climb_path(@climb))
    end

    flash.now[:alert] = @climb.errors.full_messages
    render :edit
  end

  private

  def climb_params
    params.require(:climb).permit(
      :climbed_on,
      :discipline_id,
      :grade,
      :mountain_project_lead_style,
      :mountain_project_notes,
      :mountain_project_pitches,
      :mountain_project_route_id,
      :mountain_project_style,
      :mountain_project_tick_id,
      :mountain_project_type,
      :mountain_project_user_rating,
      :mountain_project_user_stars,
      :name
    )
  end
end
