# frozen_string_literal: true

require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [375, 812] do |driver_option|
    driver_option.add_emulation(device_name: "iPhone X")
  end

  test "index" do
    visit "/"
    assert_selector "form.new_person"

    fill_in "Email", with: "climber@example.com"
    fill_in "Password", with: "secret123"
    click_on "Sign up"

    assert_selector "#climb_discipline"
  end
end
