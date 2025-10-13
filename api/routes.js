import dotenv from "dotenv";
import { register, login, modify, follow, unfollow } from "./users.js";
import { authMiddleware } from "./middlewares.js";

dotenv.config();

function basic(req, res) {
  res.status(200).json({ message: "api is on" });
}

function miscellaneous(app) {
  app.get("/", basic);
}

function userRoutes(app) {
  app.post("/user", register);
  app.get("/user", login);
  app.patch("/user", authMiddleware, modify);

  app.post("/follow", authMiddleware, follow);
  app.post("/unfollow", authMiddleware, unfollow);
}

export default function initRoutes(app) {
  miscellaneous(app);
  userRoutes(app);
}
