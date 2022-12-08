require_relative './database_connection'

class BookingRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    sql = 'SELECT * FROM bookings;'
    
    result_set = DatabaseConnection.exec_params(sql,[])

    bookings = []
    result_set.each do |result|
      bookings << format_single_result(result)
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

    booking = format_single_result(result[0])
    return booking
  end

  def find_by_guest(guest_id)
    # Executes the SQL query:
    sql = 'SELECT * FROM bookings WHERE guest_id = $1'
    params = [guest_id]

    results = DatabaseConnection.exec_params(sql,params)

    bookings = format_single_result(results)
    return bookings
  end

  end
  # Add more methods below for each operation you'd like to implement.

  def create(booking)
    # Executes the SQL query:
    sql = 'INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ($1, $2, $3, $4, $5);'
    params = [booking.check_in, booking.check_out, booking.confirmed, booking.listing_id, booking.guest_id]
    DatabaseConnection.exec_params(sql,params)
    return nil
  end

  private

  def format_single_result(result)
    booking = Booking.new
    booking.id = result["id"].to_i
    booking.check_in = result["check_in"]
    booking.check_out = result["check_out"]
    booking.confirmed = boolean(result["confirmed"])
    booking.listing_id = result["listing_id"].to_i
    booking.guest_id = result["guest_id"].to_i
    return booking
  end

  def boolean(input)
    if input == 't'
      return true
    elsif input == 'f'
      return false
    else
      return nil
    end
  end
end