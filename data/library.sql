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
    genre.genre_name,
    author.author_name
  FROM book
  JOIN books_genres ON book.id = books_genres.book_id
  JOIN genre ON books_genres.genre_id = genre.id

  JOIN books_authors ON book.id = books_authors.book_id
  JOIN author ON books_authors.author_id = author.id;

-- inserting sample data 
INSERT INTO book (book_name, published_at) VALUES
('The Great Gatsby', 1925),
('1984', 1949),
('To Kill a Mockingbird', 1960),
('Pride and Prejudice', 1813),
('The Catcher in the Rye', 1951);


INSERT INTO genre (genre_name) VALUES
('Fiction'),
('Science Fiction'),
('Classic'),
('Mystery'),
('Romance');

INSERT INTO books_genres (book_id, genre_id) VALUES
(1, 3),  -- The Great Gatsby -> Classic
(2, 2),  -- 1984 -> Science Fiction
(3, 3),  -- To Kill a Mockingbird -> Classic
(4, 5),  -- Pride and Prejudice -> Romance
(5, 3);  -- The Catcher in the Rye -> Classic

INSERT INTO author (author_name) VALUES
('F. Scott Fitzgerald'),
('George Orwell'),
('Harper Lee'),
('Jane Austen'),
('J.D. Salinger');

INSERT INTO books_authors (book_id, author_id) VALUES
(1, 1),  -- The Great Gatsby -> F. Scott Fitzgerald
(2, 2),  -- 1984 -> George Orwell
(3, 3),  -- To Kill a Mockingbird -> Harper Lee
(4, 4),  -- Pride and Prejudice -> Jane Austen
(5, 5);  -- The Catcher in the Rye -> J.D. Salinger

INSERT INTO user (first_name, last_name, birth_date, email) VALUES
('Alice', 'Johnson', '1995-08-15', 'alice.johnson@example.com'),
('Bob', 'Smith', '1988-03-22', 'bob.smith@example.com'),
('Charlie', 'Brown', '2000-06-10', 'charlie.brown@example.com'),
('Diana', 'Miller', '1992-11-05', 'diana.miller@example.com'),
('Ethan', 'Wilson', '1985-09-30', 'ethan.wilson@example.com');
