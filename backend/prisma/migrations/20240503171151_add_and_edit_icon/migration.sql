/*
  Warnings:

  - You are about to drop the column `icon` on the `categories` table. All the data in the column will be lost.
  - You are about to drop the column `balance` on the `plans` table. All the data in the column will be lost.
  - Added the required column `iconId` to the `categories` table without a default value. This is not possible if the table is not empty.
  - Added the required column `monthly` to the `plans` table without a default value. This is not possible if the table is not empty.
  - Made the column `categoryId` on table `transactions` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE `transactions` DROP FOREIGN KEY `transactions_categoryId_fkey`;

-- AlterTable
ALTER TABLE `categories` DROP COLUMN `icon`,
    ADD COLUMN `iconId` INTEGER NOT NULL;

-- AlterTable
ALTER TABLE `plans` DROP COLUMN `balance`,
    ADD COLUMN `monthly` DOUBLE NOT NULL;

-- AlterTable
ALTER TABLE `transactions` MODIFY `categoryId` INTEGER NOT NULL;

-- CreateTable
CREATE TABLE `categoriesIcon` (
    `iconId` INTEGER NOT NULL AUTO_INCREMENT,
    `iconName` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`iconId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `userCategories` (
    `userId` INTEGER NOT NULL,
    `categoryId` INTEGER NOT NULL,

    PRIMARY KEY (`userId`, `categoryId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `transactions` ADD CONSTRAINT `transactions_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `categories`(`categoryId`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `categories` ADD CONSTRAINT `categories_iconId_fkey` FOREIGN KEY (`iconId`) REFERENCES `categoriesIcon`(`iconId`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userCategories` ADD CONSTRAINT `userCategories_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`userId`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userCategories` ADD CONSTRAINT `userCategories_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `categories`(`categoryId`) ON DELETE RESTRICT ON UPDATE CASCADE;
