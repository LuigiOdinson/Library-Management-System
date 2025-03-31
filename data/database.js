import dotenv from 'dotenv'
dotenv.config()

import mysql from 'mysql2'

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
}).promise();


export async function get_books() {
  const [result] = await pool.query(`
    SELECT * FROM book
  `)
  return result
}

export async function get_single_book(id) {
  const [result] = await pool.query(`
    SELECT * FROM book
    WHERE id = ?
  `, [id])
  return result.length ? result : null
}

export async function search_book(inp) {
  const searchTerm = `%${inp}%`
  const [result] = await pool.query(`
    SELECT * FROM book 
    WHERE book_name LIKE ? 
    OR book_author LIKE ?
  `, [searchTerm, searchTerm])
  return result 
}

export async function add_book(book_name, book_author) {
  const [result] = await pool.query(`
    INSERT INTO book (book_name, book_author)
    VALUES (?, ?)  
  `, [book_name, book_author])
  const id = result.insertId
  return get_single_book(id)
}

