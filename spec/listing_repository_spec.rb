require 'listing_repository'

def reset_table
  listings_seed_sql = File.read('spec/seeds/listings_seed.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(listings_seed_sql)
end

RSpec.describe ListingRepository do
  before(:each) do
    reset_table
  end

  context "using the all method" do
    it "returns all listings" do
      repo = ListingRepository.new
      listings = repo.all
      expect(listings.length).to eq 3
      expect(listings.first.price).to eq 280.00
      expect(listings.first.user_id).to eq 1
    end
  end

  context "using the create method" do
    it "adds a new listing and return them all" do
      # get all the listing
      repo = ListingRepository.new
      listings = repo.all
      expect(listings.length).to eq 3
      expect(listings.last.price).to eq 119.70
      expect(listings.last.user_id).to eq 2

      # create a new listing
      new_listing = Listing.new
      new_listing.name = 'Skylodge Adventure Suites'
      new_listing.description = 'Have you ever wanted to sleep in a condor’s nest? Here is the next best thing! A transparent luxury capsule that hangs from the top of a mountain in the Sacred Valley of Peru.'
      new_listing.price = '367.00'
      new_listing.user_id = '3'
      new_listing.available_from = '2013-01-01'
      new_listing.available_to = '2032-01-01'

      # add the new listing to the repo and check it has been added at the end
      repo.create(new_listing)
      updated_repo = ListingRepository.new
      updated_listings = updated_repo.all
      expect(updated_listings.length).to eq 4
      expect(updated_listings.last.name).to eq 'Skylodge Adventure Suites'
      expect(updated_listings.last.description).to eq 'Have you ever wanted to sleep in a condor’s nest? Here is the next best thing! A transparent luxury capsule that hangs from the top of a mountain in the Sacred Valley of Peru.'
      expect(updated_listings.last.price).to eq 367.00
      expect(updated_listings.last.user_id).to eq 3
      expect(updated_listings.last.available_from).to eq '2013-01-01'
      expect(updated_listings.last.available_to).to eq '2032-01-01'
    end
  end


context "using the find method" do
  it "returns a listing using its id" do
    repo = ListingRepository.new
    # get the listing with id 3 from the table
    listings = repo.find(3)
    # user id of this listing is 2
    expect(listings.user_id).to eq 2
    expect(listings.name).to eq 'Eco Friendly Tiny House at Cotopaxi National Park'
    expect(listings.price).to eq 119.70
  end
end

context "using the find_with_user_id method" do
  it "returns a all the listings that belong to that user" do
    repo = ListingRepository.new
    # get all the listings from user with id 1
    listings = repo.find_with_user_id(1)

    # user 1 has 2 listings
    expect(listings.length).to eq 2

    # testing each columns for both listings
    expect(listings[0].name).to eq 'Luxury suite overlooking the Wadden Sea, Harlingen'
    expect(listings[0].description).to eq 'The luxurious spacious suite is furnished with a cozy seating area, flat-screen TV, minibar, double box spring, double sink, jacuzzi, hairdryer, bathroom with spacious rain shower and toilet. A luxury breakfast is served every morning. From the suite you have a unique view of the largest tidal area in the world: the Unesco World Heritage Site "The Wadden Sea". We will do everything in our power to ensure that you have an unforgettable stay in the Funnel!'
    expect(listings[0].price).to eq 280.00
    expect(listings[0].user_id).to eq 1
    expect(listings[0].available_from).to eq '2022-12-05'
    expect(listings[0].available_to).to eq '2028-01-12'

    expect(listings[1].name).to eq 'Luxury stay in Chamonix-Mont-Blanc, Auvergne-Rhône-Alpes, France'
    expect(listings[1].description).to eq 'Lean back, breathing in that fresh mountain air while enjoying a warm soak in the terrace’s Nordic bath. Let soaring views of Mont-Blanc inspire the day’s plan. Maybe you’ll hit the slopes, plot out a hike, or snap a few photos from a cable car on your way to a mountain-peak lookout. Back home, a roaring fire awaits. And, the sauna is ready to rejuvenate you for a night out in downtown Chamonix.'
    expect(listings[1].price).to eq 2309.50
    expect(listings[1].user_id).to eq 1
    expect(listings[1].available_from).to eq '2022-01-12'
    expect(listings[1].available_to).to eq '2025-08-28'

  end
end

end
