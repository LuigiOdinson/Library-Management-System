import dotenv from 'dotenv'
dotenv.config()

import mysql from 'mysql2'

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
}).promise();

// book functions
export async function get_books(search, genre) {
  let query = 'SELECT * FROM book_genre_author'
  let values = []
  let conditions = []

  if (search) {
    conditions.push(' WHERE book_name LIKE ? OR author_name LIKE ? ')
    const searchTerm = `%${search}%`
    values.push(searchTerm, searchTerm)
  }
  if (genre) {
    conditions.push(' WHERE genre_name LIKE ? ')
    const genreTerm = `%${genre}%`
    values.push(genreTerm)
  }
  if (conditions.length > 0) { //we have at least one condition
    query += conditions.join(' AND ')
  }

  const [result] = await pool.query(query, values)
  return result
}

export async function get_single_book(id) {
  const [result] = await pool.query(`
    SELECT * FROM book_genre_author
    WHERE id = ?
  `, [id])
  return result.length ? result : null
}

export async function add_book(book_name, book_author) {
  const [result] = await pool.query(`
    INSERT INTO book (book_name, book_author)
    VALUES (?, ?)  
  `, [book_name, book_author])
  const id = result.insertId
  return get_single_book(id)
}

export async function add_borrow(book_id, user){
  
}

// login-functions
export async function register(registerInputs) {
  const {first_name, last_name, birth_date, email} = registerInputs
  pool.query(`
    INSERT INTO user (first_name, last_name, birth_date, email)
    VALUES (?, ?, ?, ?) 
  `, [first_name, last_name, birth_date, email])
}
// find user by email
export async function login(loginInputs) {
  const {email} = loginInputs
  const [result] = await pool.query(`
    SELECT * FROM user WHERE email = ?
  `, [email])
  return result
}