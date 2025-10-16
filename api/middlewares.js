import jwt from "jsonwebtoken";
import { fromError, createErrorMap } from "zod-validation-error";
import { z } from "zod";

z.config({
  customError: createErrorMap(),
});

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

export function validate(schema) {
  return (req, res, next) => {
    const result = schema.safeParse(req.body);
    if (!result.success) {
      return res
        .status(400)
        .json({ errors: fromError(result.error).toString() });
    }
    next();
  };
}
