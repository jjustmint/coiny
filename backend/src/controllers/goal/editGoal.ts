import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface goalRequest {
	token: string;
	goalId: number;
	name: string;
	goalAmount: number;
}
const editGoal = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const reqBody: goalRequest = req.body;
		const userId = verifyToken(reqBody.token);
		await prisma.goals.update({
			where: {
				goalId: reqBody.goalId,
				userId: userId,
			},
			data: {
				name: reqBody.name,
				goalAmount: reqBody.goalAmount,
			},
		});
		return res.status(200).json({
			success: true,
			data: "Goal updated",
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
export default editGoal;
