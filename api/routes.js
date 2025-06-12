const { createUser } = require('./users');

function basic(req, res) {
	res.send("you're lost :(");
}

function initRoutes(app) {
	app.get('/', basic);
	app.post('/register', createUser);
}

module.exports = initRoutes;
