# frozen_string_literal: true

class PyramidsController < ApplicationController
  before_action :authenticate_person!

  def index
    @pyramids = current_person.pyramids.each(&:create_all_grades).each(&:mark_sends)
  end

  def edit
    @pyramid = Pyramid.find(params[:id])
    raise("Not your pyramid") unless @pyramid.person == current_person
  end

  def update
    @pyramid = Pyramid.find(params[:id])
    raise("Not your pyramid") unless @pyramid.person == current_person

    return redirect_to(edit_pyramid_path(@pyramid)) if @pyramid.update(pyramid_params)

    flash.now[:alert] = @pyramid.errors.full_messages
    render :edit
  end

  private

  def pyramid_params
    params.require(:pyramid).permit(:redpoint_grade)
  end
end
