# frozen_string_literal: true

module HomeHelper
  def pyramid_climb_class(climb)
    if climb.sent? && climb.goal?
      "sent goal btn-success"
    elsif climb.sent?
      "sent btn-light"
    elsif climb.goal?
      "goal btn-light"
    else
      "btn-light"
    end
  end
end
