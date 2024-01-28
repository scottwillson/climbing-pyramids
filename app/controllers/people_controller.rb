# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :authenticate_person!

  def edit
    @person = current_person
  end

  def update
    @person = Person.find(params[:id])
    raise("Not your account") unless @person == current_person

    return redirect_to(edit_person_path(@person)) if @person.update(person_params)

    flash.now[:alert] = @person.errors.full_messages
    render :edit
  end

  private

  def person_params
    params.require(:person).permit(:email, :mountain_project_user_id, :password)
  end
end
