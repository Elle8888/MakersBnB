require_relative './database_connection'
require_relative './request'
require_relative './booking'

class BookingRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    sql = 'SELECT * FROM bookings;'
    
    result_set = DatabaseConnection.exec_params(sql,[])

    bookings = []
    result_set.each do |result|
      bookings << format_single_booking(result)
    end
    return bookings
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    sql = 'SELECT * FROM bookings WHERE id = $1;'
    params = [id]
    result = DatabaseConnection.exec_params(sql,params)

    booking = format_single_booking(result[0])
    return booking
  end

  def find_by_listing_id(listing_id)
    sql = 'SELECT * FROM bookings WHERE listing_id = $1'
    params = [listing_id]
    result_set = DatabaseConnection.exec_params(sql, params)
    bookings = []
    if result_set.ntuples >= 1
      result_set.each do |result|
        booking = format_single_booking(result)
        bookings << booking
      end
      return bookings
    end
  end

  def find_by_guest(guest_id)
    # Executes the SQL query:
    sql = 'SELECT bookings.id, bookings.check_in, bookings.check_out, bookings.confirmed, bookings.guest_id, listings.id AS listing_id, listings.name, listings.description, listings.price, listings.user_id FROM bookings JOIN listings ON bookings.listing_id = listings.id WHERE bookings.guest_id = $1;'
    params = [guest_id]

    result_set = DatabaseConnection.exec_params(sql,params)
    requests = []
    result_set.each do |result|
      requests << format_single_request(result)
    end
    return requests
  end

  def find_by_owner_id(id)
    requests = []
      sql = 'SELECT bookings.id, bookings.check_in, bookings.check_out, bookings.confirmed, bookings.guest_id, listings.id AS listing_id, listings.name, listings.description, listings.price, listings.user_id FROM bookings JOIN listings ON bookings.listing_id = listings.id WHERE listings.user_id = $1;'
      params = [id]
      result_set = DatabaseConnection.exec_params(sql,params)
      if result_set.ntuples >= 1
        result_set.each do |result|
          request = format_single_request(result)
          requests << request
        end
      end
    return requests
  end
  # Add more methods below for each operation you'd like to implement.

  def create(booking)
    # Executes the SQL query:
    sql = 'INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ($1, $2, $3, $4, $5);'
    params = [booking.check_in, booking.check_out, booking.confirmed, booking.listing_id, booking.guest_id]
    DatabaseConnection.exec_params(sql,params)
    return nil
  end
  
  def self.approve(id)
    sql = "UPDATE bookings SET confirmed = 'Approved' WHERE id = $1;"
    params = [id]

    DatabaseConnection.exec_params(sql,params)
  end

  def self.reject(id)
    sql = "UPDATE bookings SET confirmed = 'Rejected' WHERE id = $1;"
    params = [id]

    DatabaseConnection.exec_params(sql,params)
  end

  private

  def format_single_booking(result)
    booking = Booking.new
    booking.id = result["id"].to_i
    booking.check_in = result["check_in"]
    booking.check_out = result["check_out"]
    booking.confirmed = result["confirmed"]
    booking.listing_id = result["listing_id"].to_i
    booking.guest_id = result["guest_id"].to_i
    return booking
  end

  def format_single_request(result)
    request = Request.new
    request.id = result["id"].to_i
    request.check_in = result["check_in"]
    request.check_out = result["check_out"]
    request.confirmed = result["confirmed"]
    request.guest_id = result["guest_id"].to_i
    request.listing_id = result["listing_id"].to_i
    request.name = result["name"]
    request.description = result["description"]
    request.price = result["price"]
    request.user_id = result["user_id"].to_i
    return request
  end
end