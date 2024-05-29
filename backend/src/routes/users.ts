import express from "express";
import editPic from "../controllers/user/editPic";
import editName from "../controllers/user/editName";
import getStat from "../controllers/user/getStat";
import getUser from "../controllers/user/getUser";
const usersRouter = express.Router();

usersRouter.patch("/edit/name", editName);
usersRouter.patch("/edit/profile", editPic);
usersRouter.get("/stat", getStat);
usersRouter.get("/get", getUser);

export default usersRouter;
