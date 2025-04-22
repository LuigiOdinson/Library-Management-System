import dotenv from 'dotenv'
dotenv.config()

import mysql from 'mysql2'

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
}).promise();


export async function get_books(inp) {
  if (!inp) {
    const [result] = await pool.query(`
      SELECT * FROM book_genre_author
    `)
    return result
  }
  const searchTerm = `%${inp}%`
  const [result] = await pool.query(`
    SELECT * FROM book_genre_author
    WHERE book_name LIKE ? 
    OR genre_name LIKE ?
  `, [searchTerm, searchTerm])
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

