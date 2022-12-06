# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: students

Columns:
id | name | cohort_name
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE bookings RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-01-01', '2022-01-02', false, 1, 1);
INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-01-03', '2022-01-05', false, 2, 1);
INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-02-01', '2022-02-02', false, 1, 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 makersbnb_test < seeds_bookings.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: bookings

# Model class
# (in lib/booking.rb)
class Booking
end

# Repository class
# (in lib/booking_repository.rb)
class BookingRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: bookings

# Model class
# (in lib/booking.rb)

class Booking

  # Replace the attributes by your own columns.
  attr_accessor :id, :check_in, :check_out, :confirmed, :listing_id, :guest_id
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: bookings

# Repository class
# (in lib/booking_repository.rb)

class BookingRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT * FROM bookings;

    # Returns an array of Booking objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT * FROM bookings WHERE id = $1;

    # Returns a single Booking object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(booking)
    # Executes the SQL query:
    # INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ($1, $2, $3, $4, $5);

    # Returns nil
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all bookings

repo = BookingRepository.new

bookings = repo.all

bookings.length # =>  3

bookings[0].id # =>  1
bookings[0].check_in # =>  '2022-01-01'
bookings[0].confirmed # =>  false

bookings[1].id # =>  2
bookings[1].check_out # =>  '2022-01-05'
bookings[1].listing_id # =>  2

bookings[2].id # => 3
bookings[2].guest_id # => 2

# 2
# Get a single booking

repo = BookingRepository.new

booking = repo.find(2)

booking.id # =>  1
booking.check_in # =>  '2022-01-03'
booking.check_out # =>  '2022-01-05'
booking.confirmed # => false
booking.listing_id # => 2
booking.guest_id # => 1

# 3
# Create a booking

new_booking = Booking.new
new_booking.check_in = '2022-03-01'
new_booking.check_out = '2022-03-02'
new_booking.confirmed = true
new_booking.listing_id = 1
new_booking.guest_id = 3

repo = BookingRepository.new

repo.create(new_booking)

booking = repo.find(4)

booking.check_in # => '2022-03-01'
booking.check_out # => '2022-03-02'
booking.confirmed # => true
booking.listing_id # => 1
booking.guest_id # => 3

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/booking_repository_spec.rb

def reset_bookings_table
  seed_sql = File.read('spec/seeds/seeds_bookings.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'bookings' })
  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do 
    reset_bookings_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
