require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/listing_repository'
require_relative 'lib/user_repository'
require_relative 'lib/booking_repository'
require 'bcrypt'
require_relative 'lib/booking'
require_relative 'lib/request'

# Need to take this out when merging and connect to just makersbnb
ENV['ENV'] = 'test'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/listing_repository'
    also_reload 'lib/user_repository'
    also_reload 'lib/booking_repository'
    enable :sessions
  end

  configure do
    enable :sessions

  end

  get '/' do
    return "#{session.id}"
    # return erb(:index)
  end

  get '/users' do
    repo = UserRepository.new
    @users = repo.all

    return erb(:user_all)
  end

  get '/signup/new' do

    @user = User.new
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]

    return erb(:signup)
  end

  post '/signup' do
    if invalid_users_params?
      status 400
      return ''
    end

    repo = UserRepository.new
    new_user = User.new
    new_user.username = params[:username]
    new_user.email = params[:email]
    new_user.password = params[:password]

    repo.create(new_user)

    redirect '/login'
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do

    repo = UserRepository.new
    user = repo.find_by_values(params[:email])

    unless user.nil?
      password = BCrypt::Password.new(user.password)
      if password == params[:password]
        # session['user_id'] = user.id
        # puts "SESSION: #{session.to_s}"
        # this will store the session id in the DB using UPDATE query
        # UPDATE users SET session_id=$1 WHERE id=$2;
        repo.update_session_id(user.id, session.id)

        redirect '/'
      end
    end

    status 401
    return 'Wrong user or password'
  end

  def invalid_users_params?
    return (params[:username] == nil || 
      params[:email] == nil || 
      params[:password] == nil)
  end

  get '/users/:id' do
    repo = UserRepository.new

    @users = repo.find(params[:id])

    return erb(:user_find)
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
  
  get '/listings' do
    repo = ListingRepository.new
    @all_listings = repo.all
    return erb(:listings)
  end

  get '/listings/new' do
    return erb(:new_listings)
  end

  post '/listings/new' do
    new_listing = Listing.new
    new_listing.name = params[:name]
    new_listing.description = params[:description]
    new_listing.price = params[:price]
    new_listing.user_id = params[:user_id]
    new_listing.available_from = params[:available_from]
    new_listing.available_to = params[:available_to]

    repo = ListingRepository.new
    repo.create(new_listing)
    return redirect ('/listings')
  end

  get '/requests' do  
    user_repo = UserRepository.new
    user_id = user_repo.find_by_session_id(session[:session_id]).id
    booking_repo = BookingRepository.new
    listing_repo = ListingRepository.new

    # My requests
    @requested_bookings = booking_repo.find_by_guest(user_id)
  

    # Requests to approve
    @requests_to_approve = booking_repo.find_by_owner_id(user_id)

    return erb(:requests_page)
  end

  post '/requests/approve' do
    BookingRepository.approve(params[:booking_id].to_i)
    redirect('/requests')
  end

  post '/requests/reject' do
    BookingRepository.reject(params[:booking_id].to_i)
    redirect('/requests')
  end

  private

  # It doesn't check for listing_id or guest_id because when done properly the user will not input either.
  def invalid_booking_params
    return (params[:check_in] == "" || params[:check_out] == "")
  end

end
