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

  def reset_users_table
    seed_sql = File.read('spec/seeds_users.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_users_table
  end
  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
    end
  end

  context 'GET to /users' do
      it 'list all the users' do
        response = get('/users')

        expect(response.status).to eq(200)
        expect(response.body).to match('<a href="/users/1">user1.*</a><br />')
        expect(response.body).to match('<a href="/users/2">user2.*</a><br />')
      end
  end
  context 'GET /users/:id' do
    it 'should return user1 information' do
      response = get('/users/1')

      expect(response.status).to eq(200)
      expect(response.body).to include(' <h1> Welcome user1!</h1>')
      expect(response.body).to include('email: name1@email.com')
    end
  end

  context 'GET /signup/new' do
    it 'should return a sign-up form ' do
    response = get('/signup/new')

    expect(response.status).to eq(200)
    expect(response.body).to include('<form method="POST" action="/signup">')
    expect(response.body). to include('<input type="text" name="username" value=””><br />')
    expect(response.body). to include(' <input type="text" name="email" value=””><br />')
    expect(response.body). to include(' <input type="password" name="password"><br />')
    end
  end
  context 'POST to /signup' do
    it 'returns 400 when password is missing' do
      response = post('/signup', username: 'user3', email: 'name3@gmail.com')

      expect(response.status).to eq(400)
    end

    it 'returns 400 when username is missing' do
      response = post('/signup', email: 'name3@gmail.com', password: 'password3')

      expect(response.status).to eq(400)
    end

    it 'returns 400 when email is missing' do
      response = post('/signup', username: 'user3', password: 'password3')

      expect(response.status).to eq(400)
    end

    it 'creates a new user account' do
      response = post('/signup', username: 'user3', email: 'name3@gmail.com', password: 'password3')

      expect(response.status).to eq(302)
      expect(response.body).to eq('')

      response = get('/users')

      expect(response.status).to eq(200)
      expect(response.body).to include('user3')
      expect(response.body).to include('user2')
    end
  end

  context 'GET to /login' do
    it 'returns a login form' do
      response = get('/login')

      expect(response.status).to eq(200)
      expect(response.body).to match('<input type="text" name="email" placeholder="Email" />')
      expect(response.body).to match('<input type="password" name="password" placeholder="Password" />')
    end
  end

  context 'POST to /login' do
    it 'allows the user to login with valid email and password and redirects' do
      response = post('/login', email: 'name3@email.com', password: 'user')

      expect(response.status).to eq(302)
      # expect(response).to render_template(:index)
      
    end

    # it 'directs the user to the index page' do
    #   response = post('/login', email: 'name3@email.com', password: 'password3')

    #   expect(response.status).to eq(200)
  

    it 'displays 401 for invalid log in' do
      response = post('/login', email: 'name@email.com', password: 'password3')

      expect(response.status).to eq(401)
    end
  end
end
