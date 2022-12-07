require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/listing_repository'
require_relative 'lib/listing'


DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/listing_repository'

  end

  get '/' do
    return erb(:index)
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






end
