-- AlterTable
ALTER TABLE `goals` MODIFY `currentAmount` INTEGER NULL DEFAULT 0;

-- AlterTable
ALTER TABLE `users` ADD COLUMN `name` VARCHAR(191) NOT NULL DEFAULT 'Anonymous';
