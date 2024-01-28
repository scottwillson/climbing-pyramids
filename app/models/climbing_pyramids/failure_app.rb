# frozen_string_literal: true

module ClimbingPyramids
  class FailureApp < Devise::FailureApp
    def route(_)
      :new_person_registration_url
    end
  end
end
