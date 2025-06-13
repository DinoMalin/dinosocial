require('dotenv').config();
const jwt = require('jsonwebtoken');
const { register, login, modify } = require('./users');

function authMiddleware(req, res, next) {
	try {
		const authHeader = req.headers.authorization;
		const token = authHeader.split(' ')[1];
		const userId = jwt.verify(token, process.env.JWT_PASSWORD);
		req.user = userId.userId;
		next();
	} catch (e) {
		return res.status(401).json({ error: "invalid token"});
	}
}

function basic(req, res) {
	res.status(200).json({ message: "api is on" });
}

function initRoutes(app) {
	app.get('/', basic);
	app.post('/register', register);
	app.get('/login', login);
	app.post('/modify', authMiddleware, modify)
}

module.exports = initRoutes;
