import dotenv from "dotenv";
import { register, login, getUser, modify, follow, unfollow } from "./users.js";
import { registerSchema } from "./validators.js";
import { authMiddleware, validate } from "./middlewares.js";

dotenv.config();

function basic(req, res) {
  res.status(200).json({ message: "api is on" });
}

function miscellaneous(app) {
  app.get("/", basic);
}

function userRoutes(app) {
  app.post("/login", login);

  app.post("/user", validate(registerSchema), register);
  app.get("/user", authMiddleware, getUser);
  app.patch("/user", authMiddleware, modify);

  app.post("/follow", authMiddleware, follow);
  app.post("/unfollow", authMiddleware, unfollow);
}

export default function initRoutes(app) {
  miscellaneous(app);
  userRoutes(app);
}
