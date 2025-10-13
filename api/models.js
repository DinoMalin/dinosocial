import dotenv from "dotenv";
import { Sequelize, DataTypes } from "sequelize";

dotenv.config();
export const sequelize = new Sequelize("db", "root", process.env.DB_PASSWORD, {
  host: "db",
  dialect: "postgres",
});

function arrayField(type) {
  return {
    type: DataTypes.ARRAY(type),
    defaultValue: [],
  };
}

export const User = sequelize.define("User", {
  name: DataTypes.STRING,
  avatar: DataTypes.STRING,
  banner: DataTypes.STRING,
  bio: DataTypes.STRING,
  password: DataTypes.STRING,
  following: arrayField(DataTypes.UUID),
  followers: arrayField(DataTypes.UUID),
  posts: arrayField(DataTypes.INTEGER),
  likes: arrayField(DataTypes.INTEGER),
  reposts: arrayField(DataTypes.INTEGER),
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
});

export const Post = sequelize.define("Post", {
  content: DataTypes.STRING,
  author: DataTypes.UUID,
  likes: arrayField(DataTypes.UUID),
  reposts: arrayField(DataTypes.UUID),
  answers: arrayField(DataTypes.UUID),
  parent: DataTypes.UUID,
});
