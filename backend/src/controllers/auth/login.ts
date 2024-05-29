import { PrismaClient } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import * as jwt from "jsonwebtoken";

const prisma = new PrismaClient();
interface loginRequest {
  username: string;
  password: string;
}
const login = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const reqBody: loginRequest = req.body;
    const user = await prisma.users.findFirst({
      where: {
        username: reqBody.username,
        password: reqBody.password,
      },
    });
    if (
      !user ||
      user === null ||
      user === undefined ||
      reqBody.password !== user.password
    ) {
      return res.status(400).json({
        success: false,
        data: null,
        error: "Invalid username or password",
      });
    }

    const secret = process.env.JWT_SECRET;
    const token = jwt.sign({ userId: user.userId }, secret!);

    return res.status(200).json({
      success: true,
      data: "Login success",
      error: null,
      token: token,
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
export default login;
