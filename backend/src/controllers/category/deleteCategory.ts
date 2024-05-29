import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface categoryRequest {
	token: string;
	categoryId: number;
}

const deleteCategory = async (
	req: Request,
	res: Response,
	next: NextFunction
) => {
	try {
		const reqBody: categoryRequest = req.body;
		const userId = verifyToken(reqBody.token);
		const category = await prisma.userCategories.findFirst({
			where: {
				categoryId: reqBody.categoryId,
				userId: userId,
			},
		});
		if (!category) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "Category not found",
			});
		}
		await prisma.categories.delete({
			where: {
				categoryId: reqBody.categoryId,
			},
		});
		return res.status(200).json({
			success: true,
			data: "Deleted success",
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
export default deleteCategory;
