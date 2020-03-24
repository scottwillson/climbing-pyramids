# frozen_string_literal: true

class SendsController < ApplicationController
  before_action :authenticate_person!

  def create
    grade = Grade.new(decimal: send_params[:decimal], letter: send_params[:letter])
    Climb.create!(grade: grade)
    redirect_to root_path
  end

  def destroy
    climb = Climb.find(params[:id])
    climb.destroy!
    redirect_to root_path
  end

  private

  def send_params
    params.require(:send).permit(:decimal, :letter)
  end
end
