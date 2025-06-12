require('dotenv').config();
const Err = require('./errors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { sequelize, User, Post } = require('./models');

function passwordPolicy(pw) {
	const regexp = /^(?=.*[0-9])(?=.*[!@#$%^&*_])[a-zA-Z0-9!@#$%^&*]{6,16}$/;
	return regexp.test(pw);
}

async function createUser(req, res) {
	try {
		if (!req.body || !req.body.name || !req.body.password) {
			throw new Err(400, 'bad request');
		}
	
		const name = req.body.name;
		const pw = req.body.password;

		if (!passwordPolicy(pw)) {
			throw new Err(400, 'invalid password');
		}
		
		if (await User.findOne({ where: {name: name} })) {
			throw new Err(400, 'username already exist');
		}
	
		const hash = bcrypt.hashSync(pw);
		const user = await User.create({name: name, password: hash})
		const token = await jwt.sign(
			{userId: user.id},
			process.env.JWT_PASSWORD
		);

		res.status(201).json({ token: token });
	} catch (e) {
		res.status(e.code).json({ error: e.error });
	}
}

module.exports = { createUser };
