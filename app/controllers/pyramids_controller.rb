# frozen_string_literal: true

class PyramidsController < ApplicationController
  before_action :authenticate_person!

  def edit
    @pyramid = Pyramid.find(params[:id])
    raise("Not your pyramid") unless @pyramid.person == current_person
  end

  def update
    @pyramid = Pyramid.find(params[:id])
    raise("Not your pyramid") unless @pyramid.person == current_person

    if @pyramid.update(pyramid_params)
      return redirect_to(edit_pyramid_path(@pyramid))
    end

    flash.now[:alert] = @pyramid.errors.full_messages
    render :edit
  end

  private

  def pyramid_params
    params.require(:pyramid).permit(:redpoint_grade)
  end
end
