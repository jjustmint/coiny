/*
  Warnings:

  - Added the required column `currentSave` to the `plans` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `plans` ADD COLUMN `currentSave` DOUBLE NOT NULL;
