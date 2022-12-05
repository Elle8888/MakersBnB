TRUNCATE TABLE users RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (username, email, password) VALUES ('user1', 'name1@email.com', 'password1');
INSERT INTO users (username, email, password) VALUES ('user2', 'name2@email.com', 'password2');