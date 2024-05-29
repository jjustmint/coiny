import { PrismaClient, bonusUsage } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface addMoneyRequest {
	token: string;
	amount: number;
	usage: bonusUsage;
	source: string;
}
const addMoney = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const reqBody: addMoneyRequest = req.body;
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
		await prisma.bonus.create({
			data: {
				userId: userId,
				amount: reqBody.amount,
				usage: reqBody.usage as bonusUsage,
				source: reqBody.source,
			},
		});
		const bonus = await prisma.bonus.aggregate({
			where: {
				userId: userId,
				usage: "save",
				created: {
					gte: firstDayOfMonth,
					lte: lastDayOfMonth,
				},
			},
			_sum: {
				amount: true,
			},
		});
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
				error: "No Plan on this month yet",
			});
		}
		await prisma.plans.update({
			where: {
				planId: plan.planId,
			},
			data: {
				currentSave: plan.save + bonus._sum.amount!,
			},
		});
		return res.status(200).json({
			success: true,
			data: "Money added",
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
export default addMoney;
