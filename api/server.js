const express = require('express');
const { sequelize, User, Post } = require('./models')

const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.send('this is an api');
});

async function startServer() {
	try {
		await sequelize.authenticate();
		await sequelize.sync();

		const user = await User.create({ name: 'DinoMalin', bio: 'dinomalining...'});
		console.log("user created:", user);

		app.listen(port, () => {
		  console.log(`Listening on http://localhost:${port}`);
		});
	} catch (err) {
		console.error("Error:", err);
	}
}

startServer();
