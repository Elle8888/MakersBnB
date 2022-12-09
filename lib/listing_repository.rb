require_relative 'listing'
require_relative 'database_connection'

# :id, :name, :description, :price, :user_id, :available_from, :available_to
class ListingRepository

  def all
    sql = 'SELECT * FROM listings;'
    result = DatabaseConnection.exec_params(sql, [])
    listings = []
    result.each do |record|
      listings << record_to_object(record)
    end
    return listings
  end

  def create(listing)
    sql = 'INSERT INTO listings (name, description, price, user_id, available_from, available_to) VALUES ($1, $2, $3, $4, $5, $6);'
    params = [listing.name, listing.description, listing.price, listing.user_id, listing.available_from, listing.available_to]
    result = DatabaseConnection.exec_params(sql, params)
    return result
  end

  def find(id)
    sql = 'SELECT * FROM listings WHERE id = $1;'
    params = [id]
    record = DatabaseConnection.exec_params(sql,params)[0]
    return record_to_object(record)
  end

  def find_with_user_id(user_id)
    sql = 'SELECT * FROM listings WHERE user_id = $1;'
    params = [user_id]
    result = DatabaseConnection.exec_params(sql,params)
    listings = []
    result.each do |record|
      listings << record_to_object(record)
    end
    return listings
  end

# :id, :name, :description, :price, :user_id, :available_from, :available_to
  def record_to_object(record)
    object = Listing.new
    object.id = record['id'].to_i
    object.name = record['name']
    object.description = record['description']
    object.price = record['price'].to_f
    object.user_id = record['user_id'].to_i
    object.available_from = record['available_from']
    object.available_to = record['available_to']
    return object
  end

end