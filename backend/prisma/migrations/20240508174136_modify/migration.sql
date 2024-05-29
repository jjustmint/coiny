/*
  Warnings:

  - You are about to drop the `Bonus` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `Bonus` DROP FOREIGN KEY `Bonus_userId_fkey`;

-- DropTable
DROP TABLE `Bonus`;

-- CreateTable
CREATE TABLE `bonus` (
    `bonusId` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` INTEGER NOT NULL,
    `usage` ENUM('use', 'save') NOT NULL,
    `amount` INTEGER NOT NULL,
    `source` VARCHAR(191) NOT NULL,
    `created` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`bonusId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
