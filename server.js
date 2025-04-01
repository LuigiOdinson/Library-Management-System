import express from "express"
import * as db from './data/database.js'

const app = express()
app.use(express.json())
app.use(express.static('public'))

app.get('/books', async (req, res) => {
  const books = await db.get_books()
  res.send(books)
})

app.post('/', async (req, res) => {
  const {book_name, book_author} = req.body
  const added_book = await db.add_book(book_name, book_author)
  res.status(201).send(added_book)
})

app.get('/books/:id', async (req, res) => {
  const id = req.params.id
  const book = await db.get_single_book(id)
  if (!book){
    res.status(404).send('404 not found')
    return
  }
  res.send(book)
})

app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).send("something broke")
})

app.listen(8080, () => {
  console.log("Server running on port 8080")
})