DROP DATABASE IF EXISTS Library;
CREATE DATABASE Library;
USE Library;

CREATE TABLE book (
  id INT AUTO_INCREMENT PRIMARY KEY,
  book_name VARCHAR(50) NOT NULL,
  published_at INT NOT NULL
);

CREATE TABLE genre (
  id INT AUTO_INCREMENT PRIMARY KEY,
  genre_name VARCHAR(50) NOT NULL
);

CREATE TABLE books_genres (
  book_id INT,
  genre_id INT,
  PRIMARY KEY (book_id, genre_id),
  FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES genre(id) ON DELETE CASCADE
);

CREATE TABLE author (
  id INT AUTO_INCREMENT PRIMARY KEY,
  author_name VARCHAR(50) NOT NULL
);

CREATE TABLE books_authors (
  book_id INT,
  author_id INT,
  PRIMARY KEY (book_id, author_id),
  FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES author(id) ON DELETE CASCADE
);

CREATE TABLE user (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  birth_date DATE NOT NULL,
  email VARCHAR(255) UNIQUE
);

CREATE TABLE borrow (
  id INT AUTO_INCREMENT PRIMARY KEY,
  book_id INT,
  FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE,
  user_id INT,
  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
  borrowed_at DATE NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  returned_at DATE DEFAULT NULL,
  borrow_fine DECIMAL(8, 2) NOT NULL DEFAULT 0.00
);

CREATE VIEW book_genre_author AS
  SELECT 
    book.id,
    book.book_name,
    book.published_at,
    GROUP_CONCAT(DISTINCT genre.genre_name) as genre_name,
    GROUP_CONCAT(DISTINCT author.author_name) as author_name
  FROM book
  JOIN books_genres ON book.id = books_genres.book_id
  JOIN genre ON books_genres.genre_id = genre.id

  JOIN books_authors ON book.id = books_authors.book_id
  JOIN author ON books_authors.author_id = author.id
  GROUP BY book.id;

-- inserting sample data 
INSERT INTO book (book_name, published_at) VALUES
('The Great Gatsby', 1925),
('1984', 1949),
('To Kill a Mockingbird', 1960),
('Pride and Prejudice', 1813),
('The Catcher in the Rye', 1951),
('Brave New World', 1932),
('Good Omens', 1990),
('The Hobbit', 1937),
('Murder on the Orient Express', 1934),
('The Notebook', 1996);


INSERT INTO genre (genre_name) VALUES
('Fiction'),             -- 1
('Science Fiction'),     -- 2
('Classic'),             -- 3
('Mystery'),             -- 4
('Romance'),             -- 5
('Fantasy'),             -- 6
('Thriller'),            -- 7
('Drama');               -- 8

INSERT INTO books_genres (book_id, genre_id) VALUES
(1, 3),  -- The Great Gatsby -> Classic
(2, 2),  -- 1984 -> Science Fiction
(3, 3),  -- To Kill a Mockingbird -> Classic
(4, 5),  -- Pride and Prejudice -> Romance
(5, 3),  -- The Catcher in the Rye -> Classic
(6, 2),  -- Brave New World -> Science Fiction
(6, 3),  -- Brave New World -> Classic
(7, 1),  -- Good Omens -> Fiction
(7, 6),  -- Good Omens -> Fantasy
(8, 6),  -- The Hobbit -> Fantasy
(8, 3),  -- The Hobbit -> Classic
(9, 4),  -- Murder on the Orient Express -> Mystery
(9, 7),  -- Murder on the Orient Express -> Thriller
(10, 1), -- The Notebook -> Fiction
(10, 5); -- The Notebook -> Romance

INSERT INTO author (author_name) VALUES
('F. Scott Fitzgerald'),   -- 1
('George Orwell'),         -- 2
('Harper Lee'),            -- 3
('Jane Austen'),           -- 4
('J.D. Salinger'),         -- 5
('Aldous Huxley'),         -- 6
('Neil Gaiman'),           -- 7
('Terry Pratchett'),       -- 8
('J.R.R. Tolkien'),        -- 9
('Agatha Christie'),       -- 10
('Nicholas Sparks');       -- 11

INSERT INTO books_authors (book_id, author_id) VALUES
(1, 1),  -- The Great Gatsby -> F. Scott Fitzgerald
(2, 2),  -- 1984 -> George Orwell
(3, 3),  -- To Kill a Mockingbird -> Harper Lee
(4, 4),  -- Pride and Prejudice -> Jane Austen
(5, 5),  -- The Catcher in the Rye -> J.D. Salinger
(6, 6),  -- Brave New World -> Aldous Huxley
(7, 7),  -- Good Omens -> Neil Gaiman
(7, 8),  -- Good Omens -> Terry Pratchett
(8, 9),  -- The Hobbit -> J.R.R. Tolkien
(9, 10), -- Murder on the Orient Express -> Agatha Christie
(10, 11);-- The Notebook -> Nicholas Sparks

INSERT INTO user (first_name, last_name, birth_date, email) VALUES
('Alice', 'Johnson', '1995-08-15', 'alice.johnson@example.com'),
('Bob', 'Smith', '1988-03-22', 'bob.smith@example.com'),
('Charlie', 'Brown', '2000-06-10', 'charlie.brown@example.com'),
('Diana', 'Miller', '1992-11-05', 'diana.miller@example.com'),
('Ethan', 'Wilson', '1985-09-30', 'ethan.wilson@example.com');
