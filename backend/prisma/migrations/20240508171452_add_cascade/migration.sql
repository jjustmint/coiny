-- DropForeignKey
ALTER TABLE `userCategories` DROP FOREIGN KEY `userCategories_categoryId_fkey`;

-- AddForeignKey
ALTER TABLE `userCategories` ADD CONSTRAINT `userCategories_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `categories`(`categoryId`) ON DELETE CASCADE ON UPDATE CASCADE;
