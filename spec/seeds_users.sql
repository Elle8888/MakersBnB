TRUNCATE TABLE users, bookings, listings RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (username, email, password) VALUES ('user1', 'name1@email.com', 'password1');
INSERT INTO users (username, email, password) VALUES ('user2', 'name2@email.com', 'password2');
INSERT INTO users (username, email, password) VALUES ('user3', 'name3@email.com', '$2a$12$Y1tSdO1NnaAcE2cErq1CyuSkg2gpgc84VEeuvD.HnSFcr/Nn4rYPu');

-- TRUNCATE TABLE bookings RESTART IDENTITY; -- replace with your own table name.

-- ALTER TABLE bookings DISABLE TRIGGER ALL;

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-01-01', '2022-01-02', false, 1, 1);
INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-01-03', '2022-01-05', false, 2, 1);
INSERT INTO bookings (check_in, check_out, confirmed, listing_id, guest_id) VALUES ('2022-02-01', '2022-02-02', false, 1, 2);