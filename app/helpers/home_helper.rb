module HomeHelper
  def pyramid_climb_class(climb)
    if climb.sent? && climb.goal?
      "sent goal"
    elsif climb.sent?
      "sent"
    end
  end
end
