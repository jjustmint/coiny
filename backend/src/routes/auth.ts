import express from "express";

import login from "../controllers/auth/login";
import regis from "../controllers/auth/regis";
const authRouter = express.Router();

authRouter.post("/regis", regis);
authRouter.post("/login", login);

export default authRouter;
