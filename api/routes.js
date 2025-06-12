const { createUser } = require('./users');

function basic(req, res) {
	res.status(200).json({ message: "api is on" });
}

function initRoutes(app) {
	app.get('/', basic);
	app.post('/register', createUser);
}

module.exports = initRoutes;
