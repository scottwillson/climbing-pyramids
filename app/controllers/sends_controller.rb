class SendsController < ApplicationController
  def create
    grade = Grade.new(decimal: send_params[:decimal], letter: send_params[:letter])
    Climb.create!(grade: grade)
    redirect_to root_path
  end

  private

  def send_params
    params.require(:send).permit(:decimal, :letter)
  end
end
