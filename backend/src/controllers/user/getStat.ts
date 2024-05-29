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

		const usableMoney =
			plan.monthly -
			plan.save +
			transactionsMonthly._sum.amount! +
			bonus._sum.amount!;
		const currentSave = plan.currentSave;
		const used = transactionsMonthly._sum.amount!;
		return res.status(200).json({
			success: true,
			data: { currentSave, usableMoney, used },
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
