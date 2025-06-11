const { Sequelize, DataTypes } = require('sequelize');

const sequelize = new Sequelize('db', 'root', 'dino', {
	host: 'db',
  	dialect: 'postgres'
});

const User = sequelize.define('User', {
	id: {
		type: DataTypes.UUID,
		defaultValue: DataTypes.UUIDV4,
		primaryKey: true
	},
	name: DataTypes.STRING,
	avatar: DataTypes.STRING,
	banner: DataTypes.STRING,
	bio: DataTypes.STRING,
	password: DataTypes.STRING,
	following: DataTypes.ARRAY(DataTypes.UUID),
	followers: DataTypes.ARRAY(DataTypes.UUID),
	posts: DataTypes.ARRAY(DataTypes.INTEGER),
	likes: DataTypes.ARRAY(DataTypes.INTEGER),
	reposts: DataTypes.ARRAY(DataTypes.INTEGER),
});

const Post = sequelize.define('Post', {
	content: DataTypes.STRING,
	author: DataTypes.UUID,
	likes: DataTypes.ARRAY(DataTypes.UUID),
	reposts: DataTypes.ARRAY(DataTypes.UUID),
	answers: DataTypes.ARRAY(DataTypes.UUID),
});

module.exports = {sequelize, User, Post};
