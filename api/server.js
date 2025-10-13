import express from "express";
import swaggerUi from "swagger-ui-express";
import swaggerJsdoc from "swagger-jsdoc";
import { sequelize, User, Post } from "./models.js";
import initRoutes from "./routes.js";

const app = express();
const port = 3000;

const swaggerOpts = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "API Documentation",
      version: "1.0.0",
    },
  },
  apis: ["./docs.js"],
};

const swagger = swaggerJsdoc(swaggerOpts);

app.use(express.json());
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swagger));

initRoutes(app);

async function startServer() {
  try {
    await sequelize.authenticate();
    await sequelize.sync();

    app.listen(port, () => {
      console.log(`Listening on http://localhost:${port}`);
    });
  } catch (err) {
    console.error("Error:", err);
  }
}

startServer();
