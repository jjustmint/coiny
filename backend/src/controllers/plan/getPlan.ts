import { PrismaClient } from "@prisma/client";
// import exp from 'constants';
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface planRequest {
	token: string;
}

const getPlan = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const reqQuery: planRequest = {
			token: req.query.token! as string,
		};
		const userId = verifyToken(reqQuery.token);
		const today = new Date();
		const firstDayOfMonth = new Date(
			today.getFullYear(),
			today.getMonth(),
			1
		);
		const lastDayOfMonth = new Date(
			today.getFullYear(),
			today.getMonth() + 1,
			0
		);
		const plan = await prisma.plans.findFirst({
			where: {
				userId: Number(userId),
				created: {
					gte: firstDayOfMonth,
					lte: lastDayOfMonth,
				},
			},
		});
		if (!plan) {
			return res.status(404).json({
				success: false,
				data: null,
				error: "No Plan on this month yet",
			});
		}
		return res.status(200).json({
			success: true,
			data: plan,
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

export default getPlan;
