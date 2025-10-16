import { z } from "zod";

export const registerSchema = z.object({
  name: z.string(),
  password: z.string().min(6),
});
