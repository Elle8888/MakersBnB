require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/booking'
require_relative 'lib/booking_repository'
require_relative 'lib/database_connection'

# Need to take this out when merging and connect to just makersbnb
ENV['ENV'] = 'test'
DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  get '/booking/new' do
    return erb(:create_booking)
  end

  post '/booking/new' do
    if invalid_booking_params
      status 400
      return 'You must have a check in and check out date'
    end

    new_booking = Booking.new
    new_booking.check_in = params[:check_in]
    new_booking.check_out = params[:check_out]
    new_booking.confirmed = false
    new_booking.listing_id = params[:listing_id]
    new_booking.guest_id = params[:guest_id]

    repo = BookingRepository.new
    repo.create(new_booking)

    return erb(:requested_booking)
  end


  private

  # It doesn't check for listing_id or guest_id because when done properly the user will not input either.
  def invalid_booking_params
    return (params[:check_in] == "" || params[:check_out] == "")
  end
end
