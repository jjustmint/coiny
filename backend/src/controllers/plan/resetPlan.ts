import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface planRequest {
	token: string;
}
const resetPlan = async (req: Request, res: Response, next: NextFunction) => {
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
				userId: userId,
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
				error: "no plan this month",
			});
		}
		await prisma.plans.delete({
			where: {
				planId: plan.planId,
			},
		});
		await prisma.transactions.deleteMany({
			where: {
				userId: userId,
				created: {
					gte: firstDayOfMonth,
					lte: lastDayOfMonth,
				},
			},
		});
		await prisma.bonus.deleteMany({
			where: {
				userId: userId,
				created: {
					gte: firstDayOfMonth,
					lte: lastDayOfMonth,
				},
			},
		});
		return res.status(200).json({
			success: true,
			data: "Plan Delete Success",
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
export default resetPlan;
