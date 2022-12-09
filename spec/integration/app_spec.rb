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

  def reset_users_table
    seed_sql = File.read('spec/seeds/test_seeds.sql')
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

  context "GET /listings/1" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/listings/1')


      expect(response.status).to eq(200)
      
      expect(response.body).to include('<form action="/listings/1" method="POST" class="tm-search-form tm-section-pad-2">')
      expect(response.body).to include('<input type="date" name="check_out" placeholder="Check Out" class="form-control">')
      expect(response.body).to include('<button type="submit" class="btn btn-primary tm-btn-search">Book</button>')
    end
  end

  context "POST /listings/1" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/login', email: 'name3@email.com', password: 'user')
      response = post('/listings/1', check_in: '2022-05-03', check_out: '2022-05-04', confirmed: false)

      repo = BookingRepository.new
      bookings = repo.all

      expect(response.status).to eq(200)
      expect(bookings[-1].check_in).to eq '2022-05-03'
      expect(bookings[-1].check_out).to eq '2022-05-04'
      expect(bookings[-1].listing_id).to eq 1
      expect(bookings[-1].guest_id).to eq 3
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

  context 'GET /signup' do
    it 'should return a sign-up form ' do
    response = get('/signup')

    expect(response.status).to eq(200)
    expect(response.body).to match('<form method="POST" action="/signup".*>')
    expect(response.body).to include('<input name="username" type="text" class="form-control" placeholder="Username">')
    expect(response.body).to include('<input name="email" type="text" class="form-control" placeholder="Email">')
    expect(response.body).to include('<input name="password" type="password" class="form-control" placeholder="Password">')
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
      expect(response.body).to match('<form action="/login" method="post".*>')
      expect(response.body).to match('<input name="email" type="text" class="form-control" placeholder="Email">')
      expect(response.body).to match('<input name="password" type="text" class="form-control" placeholder="Password">')
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

  context 'GET /requests' do
    it 'returns 200 OK' do
      response = post('/login', email: 'name3@email.com', password: 'user')
      response = get('/requests')

      expect(response.status).to eq (200)
      expect(response.body).to include '<h1>Requests</h1>'
      expect(response.body).to include '<h2>Requests to approve</h2>'
    end
  end

  context 'POST /requests/approve' do
    it "updates the confirmed column with approve" do
      repo = BookingRepository.new

      expect(repo.find(1).confirmed).to eq 'Waiting'

      response = post('/requests/approve', booking_id: 1)

      expect(response.status).to eq (302)
      expect(repo.find(1).confirmed).to eq 'Approved'
    end
  end

  context 'POST /requests/reject' do
    it "updates the confirmed column with reject" do
      repo = BookingRepository.new

      expect(repo.find(1).confirmed).to eq 'Waiting'

      response = post('/requests/reject', booking_id: 1)

      expect(response.status).to eq (302)
      expect(repo.find(1).confirmed).to eq 'Rejected'
    end
  end
end
