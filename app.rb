require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/listing_repository'
require_relative 'lib/listing'


class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/listing_repository'

  end

  get '/' do
    return erb(:index)
  end


  get '/listings' do
    repo =
    @all_listings =
    return erb(:listings)
  end

  get '/listings/new' do
    return erb(:new_listings)
  end
end
