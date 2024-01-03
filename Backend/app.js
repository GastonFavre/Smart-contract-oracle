const express = require('express');
const faker = require('faker');

const app = express();
const PORT = 3000;

app.get('/api/winner', (req, res) => {
  const randomName = faker.name.findName();
  res.json({ winner: randomName });
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
