require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'
require 'booking_repository'
require 'booking'

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
      expect(response.body).to include('<form action="/booking/new" method="POST" class="tm-search-form tm-section-pad-2">')
      expect(response.body).to include('<input type="date" name="check_out" placeholder="Check Out" class="form-control">')
    end
  end

  context "POST /booking/new" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/booking/new', check_in: '2022-05-03', check_out: '2022-05-04', confirmed: false, listing_id: 3, guest_id: 1)

      repo = BookingRepository.new
      bookings = repo.all

      expect(response.status).to eq(200)
      expect(bookings[-1].check_in).to eq '2022-05-03'
      expect(bookings[-1].check_out).to eq '2022-05-04'
      expect(bookings[-1].listing_id).to eq 3
      expect(bookings[-1].guest_id).to eq 1
    end
  end
end
