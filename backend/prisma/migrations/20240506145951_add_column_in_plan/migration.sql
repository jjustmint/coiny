/*
  Warnings:

  - Added the required column `dailyExpense` to the `plans` table without a default value. This is not possible if the table is not empty.
  - Added the required column `usableMoney` to the `plans` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `plans` ADD COLUMN `dailyExpense` DOUBLE NOT NULL,
    ADD COLUMN `usableMoney` DOUBLE NOT NULL;
