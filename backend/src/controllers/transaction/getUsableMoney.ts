import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface getUsableMoneyRequest {
	token: string;
}
const getUsableMoney = async (
	req: Request,
	res: Response,
	next: NextFunction
) => {
	try {
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
		const daysLeft = lastDayOfMonth.getDate() - today.getDate();
		const reqQuery: getUsableMoneyRequest = {
			token: req.query.token! as string,
		};
		const userId = verifyToken(reqQuery.token);

		const transactionsMonthly = await prisma.transactions.aggregate({
			where: {
				userId: userId,
				created: {
					gte: firstDayOfMonth,
					lte: lastDayOfMonth,
				},
			},
			_sum: {
				amount: true,
			},
		});
		const startOfDay = new Date();
		startOfDay.setHours(0, 0, 0, 0); 
		const endOfDay = new Date();
		endOfDay.setHours(23, 59, 59, 999);
		const transactionsDaily = await prisma.transactions.aggregate({
			where: {
				userId: userId,
				created: {
					gte: startOfDay,
					lte: endOfDay,
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
				error: "plan not found",
			});
		}
		const bonus = await prisma.bonus.aggregate({
			where: {
				userId: userId,
				usage: "use",
				created: {
					gte: firstDayOfMonth,
					lte: lastDayOfMonth,
				},
			},
			_sum: {
				amount: true,
			},
		});
		const dailyExpense =
			(plan.monthly - plan.save + bonus._sum.amount!) / daysLeft;;
		const currentDailyExpense =
			(dailyExpense + transactionsDaily._sum.amount!)
		const usableMoney =
			plan.monthly -
			plan.save +
			transactionsMonthly._sum.amount! +
			bonus._sum.amount!;
		return res.status(200).json({
			success: true,
			data: { usableMoney, currentDailyExpense },
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
export default getUsableMoney;
