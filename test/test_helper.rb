# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

WebMock.disable_net_connect! allow_localhost: true

class ActiveSupport::TestCase
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def stub_mountain_project_api
    stub_request(:get, %r{www.mountainproject.com/data/get-ticks})
      .to_return(body: file_fixture("mountain_project_ticks.json").read)

    stub_request(:get, %r{www.mountainproject.com/data/get-routes})
      .to_return(body: file_fixture("mountain_project_routes.json").read)
  end
end
