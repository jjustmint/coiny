import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface userRequest {
	token: string;
	image: string;
}
const editPic = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const reqBody: userRequest = req.body;
		const userId = verifyToken(reqBody.token);
		await prisma.users.update({
			where: {
				userId: userId,
			},
			data: {
				image: reqBody.image,
			},
		});

		return res.status(200).json({
			success: true,
			data: "Pic updated",
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
export default editPic;
