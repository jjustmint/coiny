import * as jwt from "jsonwebtoken";

const verifyToken = (token: string) => {
	const secret = process.env.JWT_SECRET;
	const decoded = jwt.verify(token, secret!) as jwt.JwtPayload;

	const { userId } = decoded;
	return Number(userId);
};
export default verifyToken;
