import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface goalRequest {
	token: string;
	goalId: number;
}
const deleteGoal = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const reqQuery: goalRequest = {
			token: req.query.token! as string,
			goalId: Number(req.query.goalId),
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
		const goal = await prisma.goals.findFirst({
			where: {
				userId: userId,
				goalId: reqQuery.goalId,
			},
		});
		if (!plan || !goal) {
			return res.status(404).json({
				success: false,
				data: null,
				error: "Plan or goal not found",
			});
		}
		await prisma.plans.update({
			where: {
				planId: plan.planId,
				userId: userId,
			},
			data: {
				currentSave: plan.currentSave + goal.currentAmount,
			},
		});
		await prisma.goals.delete({
			where: {
				goalId: reqQuery.goalId,
				userId: userId,
			},
		});
		return res.status(200).json({
			success: true,
			data: "Goal deleted",
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
export default deleteGoal;
