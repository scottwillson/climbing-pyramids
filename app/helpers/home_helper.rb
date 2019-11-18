module HomeHelper
  def pyramid_climb_class(climb)
    if climb.sent? && climb.goal?
      "sent goal btn-success"
    elsif climb.sent?
      "sent btn-info"
    else
      "btn-light"
    end
  end
end
