import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import * as jwt from "jsonwebtoken";

const prisma = new PrismaClient();
interface regisRequest {
	username: string;
	password: string;
}
const categoryName = [
	"Entertain",
	"Coffee",
	"Bus",
	"Food",
	"Shopping",
	"Other",
];
const iconId = [17, 25, 6, 8, 13, 24];
const regis = async (req: Request, res: Response, next: NextFunction) => {
	try {
		//get the data from the request body
		const reqBody: regisRequest = req.body;
		//check if the input is empty
		if (!reqBody.username || !reqBody.password) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "Invalid input",
			});
		}
		const alreadyExist = await prisma.users.findFirst({
			where: {
				username: reqBody.username,
			},
		});
		if (alreadyExist) {
			return res.status(400).json({
				success: false,
				data: null,
				error: "Username already exist",
			});
		}
		await prisma.users.create({
			data: {
				username: reqBody.username,
				password: reqBody.password,
			},
		});
		const user = await prisma.users.findFirst({
			where: {
				username: reqBody.username,
				password: reqBody.password,
			},
		});
		for (let i = 0; i < categoryName.length; i++) {
			var categories = await prisma.categories.create({
				data: {
					name: categoryName[i],
					iconId: iconId[i],
				},
			});
			await prisma.userCategories.create({
				data: {
					userId: user?.userId as number,
					categoryId: categories.categoryId,
				},
			});
		}
		return res.status(200).json({
			success: true,
			data: "User created",
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
export default regis;
