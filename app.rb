require 'sinatra/base'
require 'sinatra/reloader'

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

  end
end