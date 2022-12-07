require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'

require 'bcrypt'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
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
end