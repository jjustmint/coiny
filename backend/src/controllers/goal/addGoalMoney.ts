import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface goalMoneyRequest {
	token: string;
	goalId: number;
	amount: number;
}
const addGoalMoney = async (
	req: Request,
	res: Response,
	next: NextFunction
) => {
	try {
		const reqBody: goalMoneyRequest = req.body;
		const userId = verifyToken(reqBody.token);

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
				goalId: reqBody.goalId,
				userId: userId,
			},
		});
		if (!goal || !plan) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "This goal does not exist or user has no plan",
			});
		}
		const currentAmount = reqBody.amount + goal.currentAmount;

		if (
			currentAmount > goal.goalAmount ||
			reqBody.amount > goal.goalAmount
		) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "The amount is over the goal",
			});
		}

		if (currentAmount === goal.goalAmount) {
			await prisma.goals.update({
				where: {
					goalId: reqBody.goalId,
					userId: userId,
				},
				data: {
					currentAmount: currentAmount,
					status: "completed",
				},
			});
		}

		await prisma.goals.update({
			where: {
				goalId: goal.goalId,
				userId: userId,
			},
			data: {
				currentAmount: currentAmount,
			},
		});
		await prisma.plans.update({
			where: {
				planId: plan.planId,
				userId: userId,
			},
			data: {
				currentSave: plan.currentSave - reqBody.amount,
			},
		});
		return res.status(200).json({
			success: true,
			data: "Money added to goal",
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
export default addGoalMoney;
