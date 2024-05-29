-- AlterTable
ALTER TABLE `goals` ADD COLUMN `status` ENUM('ongoing', 'completed') NOT NULL DEFAULT 'ongoing';
