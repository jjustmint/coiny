import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface transactionRequest {
	token: string;
}
const getTransaction = async (
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
		const reqQuery: transactionRequest = {
			token: req.query.token! as string,
		};
		const userId = verifyToken(reqQuery.token);

		const userTransactions = await prisma.transactions.findMany({
			where: {
				userId: userId,
				created: {
					gte: firstDayOfMonth,
					lte: lastDayOfMonth,
				},
			},
			include: {
				categories: true,
			},
		});
		if (!userTransactions) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "This user hasnt made any transactions yet",
			});
		}

		return res.status(200).json({
			success: true,
			data: userTransactions,
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
export default getTransaction;
