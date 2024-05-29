import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import verifyToken from "../auth/verifyToken";

const prisma = new PrismaClient();
interface userRequest {
	token: string;
}
const getUser = async (req: Request, res: Response, next: NextFunction) => {
	try {
		const reqQuery: userRequest = {
			token: req.query.token! as string,
		};
		const userId = verifyToken(reqQuery.token);

		const user = await prisma.users.findFirst({
            where: {
                userId: userId,
            },
        });
        if (!user) {
            return res.status(404).json({
                success: false,
                data: null,
                error: "user not found",
            });
        }
		return res.status(200).json({
			success: true,
			data: user,
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
export default getUser;
