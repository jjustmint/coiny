/*
  Warnings:

  - Made the column `currentAmount` on table `goals` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE `goals` MODIFY `currentAmount` INTEGER NOT NULL DEFAULT 0;
