# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :authenticate_person!

  def edit
    @person = current_person
  end

  private

  def person_params
    params.require(:person).permit(:email)
  end
end
