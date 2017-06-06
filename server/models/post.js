import mongoose from 'mongoose'
mongoose.Promise = global.Promise;

const PostSchema = new mongoose.Schema({
  user_id: String,
  title: String,
  author: String,
  publisher: String,
  listPrice: Number,
  image: String,
  category: Number,
  condition: Number,
  price: Number,
});

const post = mongoose.model('post', PostSchema);
export default post;
