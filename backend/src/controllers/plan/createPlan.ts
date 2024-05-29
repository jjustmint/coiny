import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
//declare the type of data that will be received in body
interface planningRequest {
	token: string;
	monthly: number;
	save: number;
}
const createPlan = async (req: Request, res: Response, next: NextFunction) => {
	try {
		//get the data from the request body
		const reqBody: planningRequest = req.body;
		const userId = verifyToken(reqBody.token);
		//check if he save more than monthly
		if (reqBody.save > reqBody.monthly) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "You can't save more than you earn",
			});
		}
		//create new row in plans table
		await prisma.plans.create({
			data: {
				userId: userId,
				monthly: reqBody.monthly,
				save: reqBody.save,
				currentSave: reqBody.save,
			},
		});
		return res.status(200).json({
			success: true,
			data: "Plan created",
			error: null,
		});
	} catch (error: any) {
		console.error("Error:", error);
		return res.status(500).json({
			success: false,
			data: null,
			error: error.message,
		});
	} finally {
		await prisma.$disconnect();
	}
};

export default createPlan;
