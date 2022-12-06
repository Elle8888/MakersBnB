# {{ METHOD }} {{ PATH}} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)
  method: POST
  path: /booking/new
  body parameters: check_in, check_out, confirmed, listing_id, guest_id

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

<html>
  <head></head>
  <body>
    <h1>Your booking has ben requested!</h1>
  </body>
  <footer>
    <a href="/">Home</a>
  </footer>
</html>
```
## 3. Write Examples

_Replace these with your own design._

```
# Request:

POST /bookin/new

# Expected response:

Response for 200 OK
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /booking/new" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/booking/new', check_in: '2022-05-03', check_out: '2022-05-04', confirmed: false, listing_id: 3, guest_id: 1)

      repo = BookingRepository.new
      bookings = repo.all

      expect(response.status).to eq(200)
      expect(bookings[-1].check_in).to eq '2022-05-03'
      expect(bookings[-1].check_out).to eq '2022-05-04'
      expect(bookings[-1].listing_id).to eq 3
      expect(bookings[-1].guest_id).to eq 1
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.