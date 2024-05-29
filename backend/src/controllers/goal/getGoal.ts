import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface goalMoneyRequest {
	token: string;
}
const getGoal = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const reqQuery: goalMoneyRequest = {
			token: req.query.token! as string,
		};
		const userId = verifyToken(reqQuery.token);

		const goals = await prisma.goals.findMany({
			where: {
				userId: userId,
			},
		});
		if (!goals) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "This user hasnt set any goals yet",
			});
		}
		return res.status(200).json({
			success: true,
			data: goals,
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
export default getGoal;
