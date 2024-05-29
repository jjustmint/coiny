import express from 'express';
import addMoney from '../controllers/transaction/addMoney';
import getTransaction from '../controllers/transaction/getTransaction';
import withdraw from '../controllers/transaction/withdraw';
import getUsableMoney from "../controllers/transaction/getUsableMoney";

const transactionsRouter = express.Router();

transactionsRouter.get("/get", getTransaction);
transactionsRouter.post("/add", addMoney);
transactionsRouter.post("/withdraw", withdraw);
transactionsRouter.get("/balance", getUsableMoney);
export default transactionsRouter;