import express from 'express'
import mongoose from 'mongoose'

import post from './models/post'
import user from './models/user'

const app = express()
const port = 3001

const dbUrl = 'mongodb://localhost/textcycle'
mongoose.connect(dbUrl, dbErr => {
  if (dbErr) throw new Error(dbErr)
  else console.log('db connected')
})

// GETリクエストに対処
app.get('/api/posts', (request, response) => {
  post.find({}, (err, postsArray) => {
    if (err) respnse.status(500).send();
    else response.status(200).send(postsArray);
  })
})

app.get('/api/users/:id', (request, response) => {
  user.findById(request.params.id, (err, user) => {
    if (err) response.status(500).send()
    else response.status(200).send(user)
  })
})

/*
// POSTリクエストに対処
app.post([url], (request, response) => {
  //
})

// PUTリクエストに対処
app.put([url], (request, response) => {
  //
})

// DELETEリクエストに対処
app.delete([url], (request, response) => {
  //
})
*/
// ポートを指定してアクセスを受け付ける
app.listen(port, err => {
  if (err) throw new Error(err)
  else console.log(`listening on port ${port}`)
})
