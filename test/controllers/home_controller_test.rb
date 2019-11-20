require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "index" do
    get root_path
  end
end
