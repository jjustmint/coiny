import express from "express";
import createCategory from "../controllers/category/createCategory";
import getCategory from "../controllers/category/getCategory";
import deleteCategory from "../controllers/category/deleteCategory";
import editCategory from "../controllers/category/editCategory";
const categoriessRouter = express.Router();

categoriessRouter.post("/create", createCategory);
categoriessRouter.get("/get", getCategory);
categoriessRouter.delete("/delete", deleteCategory);
categoriessRouter.patch("/edit", editCategory);

export default categoriessRouter;
