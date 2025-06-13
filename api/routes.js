const { register, login } = require('./users');

function basic(req, res) {
	res.status(200).json({ message: "api is on" });
}

function initRoutes(app) {
	app.get('/', basic);
	app.post('/register', register);
	app.get('/login', login);
}

module.exports = initRoutes;
