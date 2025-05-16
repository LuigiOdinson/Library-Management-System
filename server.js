import express from "express"
import session from "express-session"
import * as db from './data/database.js'

const app = express()
app.use(express.json())
app.use(express.static('public'))
app.set("view engine", "ejs")
app.use(express.urlencoded({ extended: true }));

app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false
}))

app.get('/books', async (req, res) => {
  const {searchInput, genreFilter} = req.query
  const books = await db.get_books(searchInput, genreFilter)
  const user = req.session.user
  res.render('books.ejs', {books, user})
})

app.get('/books/:id', async (req, res) => {
  const book_id = req.params.id
  const user = req.session.user
  const [book] = await db.get_single_book(book_id)
  if (!book){
    res.status(404).send('404 not found')
    return
  }
  res.render('singleBook.ejs', {book, user})
})

// register routes 
app.get('/register', (req, res) => {
  res.render('register.ejs')
})

app.post('/register', (req, res) => {
  const registerInputs = req.body
  db.register(registerInputs)
  res.redirect('/books')
})

// login routes
app.get('/login', (req, res) => {
  res.render('login.ejs')
})

app.post('/login', async (req, res) => {
  const loginInputs = req.body
  const user = await db.login(loginInputs)
  if (user.length > 0) {
    req.session.user = user[0]
    res.redirect('/books')
  } else {
    res.send('user not found')
  }
})

app.get('/logout', (req, res) => {
  // deletes all session data for that user
  req.session.destroy(err => {
    if (err) {
      res.send('Could not log out')
      return
    }
    res.redirect('/books')
  })
})

// borrowing
app.post('/borrow/:id', async (req, res) => {
  const book_id = req.params.id
  const user_id = req.session.user.id
  db.add_borrow(book_id, user_id)
  res.redirect('/books')
})

// running server
app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).send("something broke")
})

app.listen(8080, () => {
  console.log("Server running on port 8080")
})