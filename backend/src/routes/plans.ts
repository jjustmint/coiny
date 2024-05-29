import express from "express";
import createPlan from "../controllers/plan/createPlan";
import resetPlan from "../controllers/plan/resetPlan";
import getPlan from "../controllers/plan/getPlan";
const plansRouter = express.Router();

plansRouter.post("/create", createPlan);
plansRouter.delete("/reset", resetPlan);
plansRouter.get("/get", getPlan);

export default plansRouter;
