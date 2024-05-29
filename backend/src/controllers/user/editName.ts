import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface userRequest {
	token: string;
	name: string;
}
const editName = async (req: Request, res: Response, next: NextFunction) => {
	try {
		//ก่อนupdate find unique ของ user  prisma.user.findUnique if เป็นเนา
		const reqBody: userRequest = req.body;
		const userId = verifyToken(reqBody.token);
		await prisma.users.update({
			where: {
				userId: userId,
			},
			data: {
				name: reqBody.name,
			},
		});

		return res.status(200).json({
			success: true,
			data: "Name updated",
			error: null,
		});
	} catch (error: any) {
		console.error("Error:", error);
		return res.status(500).json({
			success: false,
			data: null,
			error: error.message,
		});
	}
};
export default editName;
