TRUNCATE TABLE users, bookings, listings RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (username, email, password) VALUES ('user1', 'name1@email.com', 'password1');
INSERT INTO users (username, email, password) VALUES ('user2', 'name2@email.com', 'password2');
INSERT INTO users (username, email, password) VALUES ('user3', 'name3@email.com', '$2a$12$Y1tSdO1NnaAcE2cErq1CyuSkg2gpgc84VEeuvD.HnSFcr/Nn4rYPu');

INSERT INTO listings (name, description, price, user_id, available_from, available_to) VALUES
(
  'Luxury suite overlooking the Wadden Sea, Harlingen',
  'The luxurious spacious suite is furnished with a cozy seating area, flat-screen TV, minibar, double box spring, double sink, jacuzzi, hairdryer, bathroom with spacious rain shower and toilet. A luxury breakfast is served every morning. From the suite you have a unique view of the largest tidal area in the world: the Unesco World Heritage Site "The Wadden Sea". We will do everything in our power to ensure that you have an unforgettable stay in the Funnel!',
  '280.00',
  '1',
  '2022-12-05',
  '2028-01-12'
),

(
  'Luxury stay in Chamonix-Mont-Blanc, Auvergne-Rhône-Alpes, France',
  'Lean back, breathing in that fresh mountain air while enjoying a warm soak in the terrace’s Nordic bath. Let soaring views of Mont-Blanc inspire the day’s plan. Maybe you’ll hit the slopes, plot out a hike, or snap a few photos from a cable car on your way to a mountain-peak lookout. Back home, a roaring fire awaits. And, the sauna is ready to rejuvenate you for a night out in downtown Chamonix.',
  '2309.50',
  '1',
  '2022-01-12',
  '2025-08-28'
),

(
  'Eco Friendly Tiny House at Cotopaxi National Park',
  'This is a brand new tiny house with a loft design, dramatic windows, and soaring ceilings. Due to its strategic location in the valley of the volcanoes it provides unmatched 360 degree views of the mountains and night sky. Isolated and at 3650m on a high flat plain it is within an exclusive and private 19 hectare reserve, a 10min drive to the Cotopaxi National Park. On a clear day there are views of up to 7 volcanos. Accessible only with a 4x4 vehicle with clearance. Pets Welcome.',
  '119.70',
  '2',
  '2022-12-05',
  '2028-01-12'
);

INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-01-01', '2022-01-02', 'Waiting', 1, 1);
INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-01-03', '2022-01-05', 'Waiting', 2, 1);
INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-02-01', '2022-02-02', 'Waiting', 1, 2);