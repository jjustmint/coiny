import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface categoryRequest {
	token: string;
}

const getCategory = async (req: Request, res: Response, next: NextFunction) => {
	const reqQuery: categoryRequest = { token: req.query.token! as string };
	const userId = verifyToken(reqQuery.token);

	try {
		const category =
			await prisma.$queryRaw`SELECT categoriesIcon.iconName,categories.name 
            FROM categoriesIcon,categories,userCategories
            WHERE userCategories.userId = ${userId} 
            AND categories.categoryId = userCategories.categoryId 
            AND categories.iconId = categoriesIcon.iconId;`;
		if (!category) {
			return res.status(404).json({
				success: false,
				data: null,
				error: "Category not found",
			});
		}
		return res.status(200).json({
			success: true,
			data: category,
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
export default getCategory;
