const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.send('Bienvenue sur mon API');
});

app.get('/api/users', (req, res) => {
  res.json([
    { id: 1, nom: 'Alice' },
    { id: 2, nom: 'Bob' }
  ]);
});

app.post('/api/users', (req, res) => {
  const user = req.body;
  res.status(201).json({ message: 'Utilisateur créé', user });
});

app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}`);
});


app.get('/api/hello', (req, res) => {
	res.send(req);
})
