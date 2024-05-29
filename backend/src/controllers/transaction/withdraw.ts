import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface withdrawRequest {
	token: string;
	category: string;
	amount: number;
}
const withdraw = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const reqBody: withdrawRequest = req.body;
		const userId = verifyToken(reqBody.token);
		const category = await prisma.categories.findFirst({
			where: {
				name: reqBody.category,
			},
		});
		if (!category) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "This category does not exist",
			});
		}
		await prisma.transactions.create({
			data: {
				userId: userId,
				categoryId: category.categoryId,
				amount: -1 * reqBody.amount,
			},
		});
		return res.status(200).json({
			success: true,
			data: "Withdraw created",
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
export default withdraw;
