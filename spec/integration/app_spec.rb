require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.


  context "GET /" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/booking/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Make a booking!</h1>')
      expect(response.body).to include('<form action="/booking/new" method="POST">')
      expect(response.body).to include('<input type="date" name="check_out">')
      expect(response.body).to include('<div>Guest id:</div>')
    end
  end
end
