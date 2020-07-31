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

    select "Outdoor Lead"
    select "5.10d"
    click_on "Create"

    discipline = Discipline.find_by(name: "Outdoor Lead")
    assert_selector("h3", text: "Outdoor Lead")
    assert_selector "#climb-#{discipline.id}-0-0", text: "5.11c"
    assert_selector "#climb-#{discipline.id}-3-0.sent", text: "5.10d"

    click_on "Climbs"
    assert_selector("table.climbs")

    click_on "Create"
    fill_in "Name", with: "Slab"
    select "5.10b"
    click_on "Create"
    assert_selector(".pyramid")
  end
end
