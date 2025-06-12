const express = require('express');
const { sequelize, User, Post } = require('./models')
const initRoutes = require('./routes');

const app = express();
const port = 3000;

app.use(express.json());

initRoutes(app);

async function startServer() {
	try {
		await sequelize.authenticate();
		await sequelize.sync();

		app.listen(port, () => {
		  console.log(`Listening on http://localhost:${port}`);
		});
	} catch (err) {
		console.error("Error:", err);
	}
}

startServer();
