-- AddForeignKey
ALTER TABLE `bonus` ADD CONSTRAINT `bonus_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`userId`) ON DELETE CASCADE ON UPDATE CASCADE;
