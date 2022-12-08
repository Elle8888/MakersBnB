require 'booking_repository'
require 'booking'
require 'database_connection'
def reset_bookings_table
  seed_sql = File.read('spec/seeds/test_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do 
    reset_bookings_table
  end

  # 1
  it "Get all bookings" do
    repo = BookingRepository.new

    bookings = repo.all

    expect(bookings.length).to eq 3

    expect(bookings[0].id).to eq 1
    expect(bookings[0].check_in).to eq '2022-01-01'
    expect(bookings[0].confirmed).to eq 'Waiting'

    expect(bookings[1].id).to eq 2
    expect(bookings[1].check_out).to eq '2022-01-05'
    expect(bookings[1].listing_id).to eq 2

    expect(bookings[2].id).to eq 3
    expect(bookings[2].guest_id).to eq 2
  end

  # 2
  it "Get a single booking" do
    repo = BookingRepository.new

    booking = repo.find(2)

    expect(booking.id).to eq 2  
    expect(booking.check_in).to eq '2022-01-03'
    expect(booking.check_out).to eq '2022-01-05'
    expect(booking.confirmed).to eq 'Waiting'
    expect(booking.listing_id).to eq 2
    expect(booking.guest_id).to eq 1
  end

  # 3
  it "Create a booking" do
    new_booking = Booking.new
    new_booking.check_in = '2022-03-01'
    new_booking.check_out = '2022-03-02'
    new_booking.confirmed = 'Waiting'
    new_booking.listing_id = 1
    new_booking.guest_id = 3

    repo = BookingRepository.new

    repo.create(new_booking)
    booking = repo.find(4)

    expect(booking.check_in).to eq '2022-03-01'
    expect(booking.check_out).to eq '2022-03-02'
    expect(booking.confirmed).to eq 'Waiting'
    expect(booking.listing_id).to eq 1
    expect(booking.guest_id).to eq 3
  end

  it "returns all bookings by guest_id" do
    repo = BookingRepository.new
    bookings =repo.find_by_guest(1)

    expect(bookings)
  end

  it "returns all requests when given an owner ID" do
    repo = BookingRepository.new

    requests = repo.find_by_owner_id(1)

    expect(requests.length).to eq 3
    expect(requests[0].id).to eq 1
    expect(requests[2].check_in).to eq '2022-02-01'
  end

  it "approves a booking" do
    repo = BookingRepository.new
    booking = repo.find(1)
    expect(booking.confirmed).to eq 'Waiting'

    BookingRepository.approve(1)
    booking = repo.find(1)
    expect(booking.confirmed).to eq 'Approved'
  end

  it "rejects a booking" do
    repo = BookingRepository.new
    booking = repo.find(1)
    expect(booking.confirmed).to eq 'Waiting'

    BookingRepository.reject(1)
    booking = repo.find(1)
    expect(booking.confirmed).to eq 'Rejected'
  end
end