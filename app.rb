require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
  end

  get '/' do
    return erb(:index)
  end

  get '/users' do
    repo = UserRepository.new
    @users = repo.all

    return erb(:user_all)
  end

  get '/signup/new' do

    return erb(:user_create)
  end
  
  post '/signup' do
    p params

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

    return ''
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do

    # if invalid__users_params?
    #   status 400
    #   return 'WRONG'
    # end

    repo = UserRepository.new
    user = repo.find_by_values(params[:email], params[:password])
    unless user.nil?
      session['user_id'] = user.id
      redirect '/'
    end

    status 401
    return 'Wrong user or password'
  end

  def invalid_users_params?
    if params[:name] == nil
      puts "no name"
      return false
    end

    if params[:username] == nil
      puts "no username"
      return false
    end

    if params[:email] == nil
      puts "no email"
      return false
    end

    if params[:password] == nil
      puts "no password"
      return false
    end

      # return ( ||
      # params[:username] == nil ||
      # params[:email] == nil ||
      # params[:password] == nil)
  end

  # add validadtion for ID to make sure its a number

  get '/users/:id' do
    repo = UserRepository.new

    @users = repo.find(params[:id])

    return erb(:user_find)
  end
end