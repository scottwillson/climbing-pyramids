# frozen_string_literal: true

class ClimbingPyramids::FailureApp < Devise::FailureApp
  def route(_)
    :new_person_registration_url
  end
end
