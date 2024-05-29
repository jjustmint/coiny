import express from "express";
import createGoal from "../controllers/goal/createGoal";
import addGoalMoney from "../controllers/goal/addGoalMoney";
import getGoal from "../controllers/goal/getGoal";
import editGoal from "../controllers/goal/editGoal";
import deleteGoal from "../controllers/goal/deleteGoal";
const goalsRouter = express.Router();

goalsRouter.post("/create", createGoal);
goalsRouter.patch("/add", addGoalMoney);
goalsRouter.get("/get", getGoal);
goalsRouter.patch("/edit", editGoal);
goalsRouter.delete("/delete", deleteGoal);
export default goalsRouter;
