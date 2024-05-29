import express, { Express } from "express";
import dotenv from "dotenv";
import plansRouter from "./routes/plans";
import usersRouter from "./routes/users";
import goalsRouter from "./routes/goals";
import categoriesRouter from "./routes/categories";
import transactionsRouter from "./routes/transactions";
import authRouter from "./routes/auth";
const app: Express = express();

const port = process.env.PORT;
dotenv.config();

app.use(express.json());
app.use("/plans", plansRouter);
app.use("/users", usersRouter);
app.use("/goals", goalsRouter);
app.use("/categories", categoriesRouter);
app.use("/transactions", transactionsRouter);
app.use("/auth", authRouter);

app.listen(port, () => {
	console.log(`[server]: Server is running at http://localhost:${port}`);
});
