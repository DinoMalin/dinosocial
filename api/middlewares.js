import jwt from "jsonwebtoken";

export function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader.split(" ")[1];
    const userId = jwt.verify(token, process.env.JWT_PASSWORD);
    req.user = userId.userId;
    next();
  } catch (e) {
    return res.status(401).json({ error: "invalid token" });
  }
}
