import express, { text } from 'express';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';
import cors from 'cors';
import dotenv from 'dotenv';

const app = express();

dotenv.config();

app.use(bodyParser.json({ limit: '30mb', extended: true }));
app.use(bodyParser.urlencoded({ limit: '30mb', extended: true }));
app.use(cors());

//create a schema for the text
const textSchema = {
  text: {
    type: String,
    required: true
  },
  emoji: {
    type: String,
    required: false
  },
  creator: {
    type: String,
    required: false
  },
  createdAt: {
    type: String,
    default: new Date().toLocaleString('sl-SI', { timeZone: 'Europe/Ljubljana' })
  }
};
const Text = mongoose.model('text', textSchema);

app.get('/', (req, res) => {
  res.send('Hello to textShower API');
});

app.get('/text', async (req, res) => {
  try {
    let text = await Text.findOne({ creator: { $ne: 'watch' } }).sort({ createdAt: -1 }).limit(1);
    if(text == null) text = {};
    res.status(200).json(text);
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
});

app.post('/text', async (req, res) => {
  const text = req.body.text;
  let emoji = req.body.emoji || null;
  let creator = req.body.creator || null;
  try {
    const newText = await Text.create({ text, emoji, creator });
    res.status(201).json({ message: "succesfully sent <3" });
  } catch (error) {
    res.status(409).json({ message: error.message });
  }
});

const PORT = process.env.PORT || 5000;

mongoose.connect(process.env.CONNECTION_URL, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => app.listen(PORT, () => console.log(`Server running on port: ${PORT}`)))
  .catch((error) => console.log(error.message));