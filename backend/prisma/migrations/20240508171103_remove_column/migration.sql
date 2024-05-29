/*
  Warnings:

  - You are about to drop the column `dailyExpense` on the `plans` table. All the data in the column will be lost.
  - You are about to drop the column `usableMoney` on the `plans` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `plans` DROP COLUMN `dailyExpense`,
    DROP COLUMN `usableMoney`;
