# Two Tables Design Recipe Template

_Copy this recipe template to design and create two related database tables from a specification._

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

- - - - -
Sign-up
As a user
So that I can list a space that belongs to me
I want to sign up to makersbnb
- - - - -

- - - - -
List multiple space
As a user
So that I can  …
I want to list multiple spaces
- - - - -

- - - - -
Listing info
As a user
So that I can specifically describe my listings
I want to name their space, provide a short description of the space, and a price per night
- - - - -

- - - - -  
Show available dates
As a user,
So that people can see when my space is available
I want to be able to give a range of dates my space is available
- - - - -

- - - - -
Request to book
As a user,
So that I can stay in a space
I want to be able to request to hire the space (for one night)
- - - - -

- - - - -
Approve a booking
As a user,
So that I know who is staying in my space
I want to be able to approve who stays in my space
- - - - -

- - - - -
Double booking
As a user
So that a space can’t be double booked
I want to know when a space is already booked
- - - - -

- - - - -
Booking confirmation
As a user
So that I can no one else books my space,
I want to receive confirmation for my booking
- - - - -




```
| Record                | Properties          |
| --------------------- | ------------------  |
| users                 | id, email, username, password
| listings              | id, name, description, price, user_id, available_from, available_to
| bookings              | id, check_in, check_out, confirmed, listing_id, guest_id






a comment links to one post
a post doesn't link to one comment
inside the post are many comments
whatever is inside (sub), is going to have an id
of what is it wrapped around
so comments have a post_id their refer to

```
Nouns:

students, student_name, cohort_name, cohort_starting_date, student_cohort
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| students              | name, cohort_id
| cohorts                | name, starting_date

1. Name of the first table (always plural): `students`

    Column names: `name`, `cohort_id`

2. Name of the second table (always plural): `cohorts`

    Column names: `name`, `starting_date`


## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

| Record                | Properties          |
| --------------------- | ------------------  |
| students              | name, cohort_id
| cohorts               | name, starting_date

Table: students
id: SERIAL
name: text
cohort_id: fk

Table: cohorts
id: SERIAL
name: text
starting_date: timestamp
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
2. Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

1. Can one [CONCERTS] have many [VENUES]? (No)
2. Can one [VENUES] have many [CONCERTS]? (Yes)

You'll then be able to say that:

1. **[A] has many [B]**
2. And on the other side, **[B] belongs to [A]**
3. In that case, the foreign key is in the table [B]

1. **VENUES has many CONCERTS**
2. And on the other side, **CONCERTS belongs to VENUES**
3. In that case, the foreign key is in the table CONCERTS

VENUES -> ONE TO MANY -> CONCERTS
CONCERTS -> MANY TO ONE -> CONCERTS

FOREIGN KEY -> 'VENUE_ID' ON CONCERTS

VENUES
1 - O2
2 - Royal Albert Hall

CONCERTS
  artis_name   venue_id
1 Pixies         1
2 ABBA           1
3 Parcels        2


Replace the relevant bits in this example with your own:

```
# EXAMPLE

1. Can one artist have many albums? YES
2. Can one album have many artists? NO

-> Therefore,
-> An artist HAS MANY albums
-> An album BELONGS TO an artist

-> Therefore, the foreign key is on the albums table.
```

*If you can answer YES to the two questions, you'll probably have to implement a Many-to-Many relationship, which is more complex and needs a third table (called a join table).*

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: albums_table.sql

-- Replace the table name, columm names and types.
| Record                | Properties          |
| --------------------- | ------------------  |
| users                 | id, email, username, password
| listings              | id, name, description, price, user_id, available_from, available_to
| bookings              | id, check_in, check_out, confirmed, listing_id, guest_id


Database name: makersbnb
Test database: makersbnb_test

-- Create the table without the foreign key first.
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email text,
  username text,
  password text
);


-- Then the table with the foreign key first.
CREATE TABLE listings (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price decimal(12,2),
  user_id int,
  available_from date,
  available_to date,

  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  check_in date,
  check_out date,
  confirmed boolean,
  listing_id int,
  guest_id int,

  constraint fk_listing foreign key(listing_id)
    references listings(id)
    on delete cascade,

    constraint fk_guest foreign key(guest_id)
      references users(id)
      on delete cascade
);


```
```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 database_name < albums_table.sql
```
