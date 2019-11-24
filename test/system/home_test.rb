require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "index" do
    visit "/"
    assert_selector "div.pyramid"
    assert_selector "#climb-3-0", text: "5.6"
    click_on "climb-3-0"
    assert_selector "#climb-3-0.sent", text: "5.6"
    click_on "climb-3-0"
    assert_no_selector "#climb-3-0.sent", text: "5.6"
  end
end
