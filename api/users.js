require('dotenv').config();
const Err = require('./errors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { sequelize, User, Post } = require('./models');

function passwordPolicy(pw) {
	const regexp = /^(?=.*[0-9])(?=.*[!@#$%^&*_])[a-zA-Z0-9!@#$%^&*]{6,16}$/;
	return regexp.test(pw);
}

async function register(req, res) {
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

async function login(req, res) {
	try {
		if (!req.query || !req.query.name || !req.query.password) {
			throw new Err(400, 'bad request');
		}

		const name = req.query.name;
		const pw = req.query.password;

		const user = await User.findOne({ where: {name: name}});
		if (!user) {
			throw new Err(400, 'invalid username');
		}

		if (!bcrypt.compareSync(pw, user.password)) {
			throw new Err(400, 'invalid password');
		}

		const token = await jwt.sign(
			{userId: user.id},
			process.env.JWT_PASSWORD
		);
		res.status(200).json({ token: token });
	} catch (e) {
		res.status(e.code).json({ error: e.error });
	}
}

async function modify(req, res) {
	try {
		if (!req.body ||
			!req.body.name ||
			!req.body.avatar ||
			!req.body.banner ||
			!req.body.bio
		) {
			throw new Err(400, 'bad request');
		}

		await User.update({
			name: req.body.name,
			avatar: req.body.avatar,
			banner: req.body.banner,
			bio: req.body.bio,
		}, { where: {id: req.user} })

		res.status(200).json({ message: "success"})
	} catch (e) {
		res.status(e.code).json({ error: e.error });
	}
}

async function follow(req, res) {
	try {
		if (!req.body || !req.body.name) {
			throw new Err(400, 'bad request');
		}

		const userToFollow = await User.findOne({
			where: {name: req.body.name}
		});
		if (!userToFollow) {
			throw new Err(400, 'invalid username');
		}

		const user = await User.findOne({
			where: {id: req.user}
		});
		if (user.id == userToFollow.id) {
			throw new Err(400, 'self follow');
		}
		if (user.following.includes(userToFollow.id)) {
			throw new Err(400, 'already followed');
		}

		userToFollow.followers = [...userToFollow.followers, user.id];
		user.following = [...user.following, userToFollow.id];
		await user.save();
		await userToFollow.save();

		res.status(200).json({ message: "success" });
	} catch (e) {
		res.status(e.code).json({ error: e.error });
	}
}

async function unfollow(req, res) {
	try {
		if (!req.body || !req.body.name) {
			throw new Err(400, 'bad request');
		}

		const userToUnfollow = await User.findOne({
			where: {name: req.body.name}
		});
		if (!userToUnfollow) {
			throw new Err(400, 'invalid username');
		}
	
		const user = await User.findOne({
			where: {id: req.user}
		});
		if (user.id == userToUnfollow.id) {
			throw new Err(400, 'self unfollow');
		}
		if (!user.following.includes(userToUnfollow.id)) {
			throw new Err(400, 'not followed');
		}

		userToUnfollow.followers = userToUnfollow.followers
			.filter((id) => {id != user.id});
		user.following = user.following
			.filter(id => id != userToUnfollow.id);
		await user.save();
		await userToUnfollow.save();

		res.status(200).json({ message: "success" });
	} catch (e) {
		res.status(e.code).json({ error: e.error });
	}
}

module.exports = { register, login, modify, follow, unfollow };
