require 'test_helper'

class HomeTest < ActionDispatch::IntegrationTest
  test "index" do
    get "/"
    assert_select "div.pyramid"
  end
end
