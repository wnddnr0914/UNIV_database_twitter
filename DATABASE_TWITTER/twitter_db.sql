-- MySQL Workbench Forward Engineering
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `twitter_DB` DEFAULT CHARACTER SET utf8 ;
USE `twitter_DB` ;

-- -----------------------------------------------------
-- Table `mydb`.`USER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`USER` (
  `idUSER` VARCHAR(20) NOT NULL,
  `NAME` VARCHAR(20) NOT NULL,
  `GENDER` INT NOT NULL,
  `BIRTH` DATE NOT NULL,
  `PASSWORD` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idUSER`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FOLLOW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`FOLLOW` (
  `FOLLOWING` VARCHAR(20) NOT NULL,
  `FOLLOWER` VARCHAR(20) NOT NULL,
  INDEX `fk_table1_USER_idx` (`FOLLOWING` ASC) VISIBLE,
  INDEX `fk_table1_USER1_idx` (`FOLLOWER` ASC) VISIBLE,
  PRIMARY KEY (`FOLLOWING`, `FOLLOWER`),
  CONSTRAINT `fk_table1_USER`
    FOREIGN KEY (`FOLLOWING`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_table1_USER1`
    FOREIGN KEY (`FOLLOWER`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`POST`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`POST` (
  `idPOST` INT NOT NULL,
  `USER_idUSER` VARCHAR(20) NOT NULL,
  `detail` VARCHAR(100) NULL,
  `DATE` TIMESTAMP NULL,
  `POSTcol` VARCHAR(45) NULL,
  PRIMARY KEY (`idPOST`),
  INDEX `fk_POST_USER1_idx` (`USER_idUSER` ASC) VISIBLE,
  CONSTRAINT `fk_POST_USER1`
    FOREIGN KEY (`USER_idUSER`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`POST_LIKE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`POST_LIKE` (
  `POST_idPOST` INT NOT NULL,
  `USER_idUSER` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`POST_idPOST`, `USER_idUSER`),
  INDEX `fk_POST_LIKE_USER1_idx` (`USER_idUSER` ASC) VISIBLE,
  CONSTRAINT `fk_POST_LIKE_POST1`
    FOREIGN KEY (`POST_idPOST`)
    REFERENCES `mydb`.`POST` (`idPOST`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_POST_LIKE_USER1`
    FOREIGN KEY (`USER_idUSER`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`POST_COMMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`POST_COMMENT` (
  `SEQ_POST` INT NOT NULL,
  `POST_idPOST` INT NOT NULL,
  `USER_idUSER` VARCHAR(20) NOT NULL,
  `DETAIL` VARCHAR(45) NULL,
  `DATE` TIMESTAMP NULL,
  PRIMARY KEY (`SEQ_POST`),
  INDEX `fk_POSTCOMMENT_POST1_idx` (`POST_idPOST` ASC) VISIBLE,
  INDEX `fk_POSTCOMMENT_USER1_idx` (`USER_idUSER` ASC) VISIBLE,
  CONSTRAINT `fk_POSTCOMMENT_POST1`
    FOREIGN KEY (`POST_idPOST`)
    REFERENCES `mydb`.`POST` (`idPOST`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_POSTCOMMENT_USER1`
    FOREIGN KEY (`USER_idUSER`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`GROUP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`GROUP` (
  `SEQ_GROUP` INT NOT NULL,
  `G_NAME` VARCHAR(45) NULL,
  PRIMARY KEY (`SEQ_GROUP`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`JOIN_GROUP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`JOIN_GROUP` (
  `USER_idUSER` VARCHAR(20) NOT NULL,
  `GROUP_SEQ_GROUP` INT NOT NULL,
  PRIMARY KEY (`USER_idUSER`, `GROUP_SEQ_GROUP`),
  INDEX `fk_JOINGROUP_GROUP1_idx` (`GROUP_SEQ_GROUP` ASC) VISIBLE,
  CONSTRAINT `fk_JOINGROUP_USER1`
    FOREIGN KEY (`USER_idUSER`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_JOINGROUP_GROUP1`
    FOREIGN KEY (`GROUP_SEQ_GROUP`)
    REFERENCES `mydb`.`GROUP` (`SEQ_GROUP`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`REPLY_COMMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`REPLY_COMMENT` (
  `POSTCOMMENT_SEQ_POST` INT NOT NULL,
  `RECOMMENT_SEQ` INT NOT NULL,
  `DETAIL` VARCHAR(45) NOT NULL,
  `DATE` TIMESTAMP NULL,
  PRIMARY KEY (`RECOMMENT_SEQ`),
  CONSTRAINT `fk_REPLYCOMMENT_POSTCOMMENT1`
    FOREIGN KEY (`POSTCOMMENT_SEQ_POST`)
    REFERENCES `mydb`.`POST_COMMENT` (`SEQ_POST`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`COMMENT_LIKE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`COMMENT_LIKE` (
  `POSTCOMMENT_SEQ_POST` INT NOT NULL,
  `USER_idUSER` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`POSTCOMMENT_SEQ_POST`, `USER_idUSER`),
  INDEX `fk_COMMENTLIKE_USER1_idx` (`USER_idUSER` ASC) VISIBLE,
  CONSTRAINT `fk_COMMENTLIKE_POSTCOMMENT1`
    FOREIGN KEY (`POSTCOMMENT_SEQ_POST`)
    REFERENCES `mydb`.`POST_COMMENT` (`SEQ_POST`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_COMMENTLIKE_USER1`
    FOREIGN KEY (`USER_idUSER`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`REPLYCOMMENTLIKE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`REPLYCOMMENTLIKE` (
  `REPLYCOMMENT_RECOMMENT_SEQ` INT NOT NULL,
  `USER_idUSER` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`REPLYCOMMENT_RECOMMENT_SEQ`, `USER_idUSER`),
  INDEX `fk_REPLYCOMMENTLIKE_USER1_idx` (`USER_idUSER` ASC) VISIBLE,
  CONSTRAINT `fk_REPLYCOMMENTLIKE_REPLYCOMMENT1`
    FOREIGN KEY (`REPLYCOMMENT_RECOMMENT_SEQ`)
    REFERENCES `mydb`.`REPLY_COMMENT` (`RECOMMENT_SEQ`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REPLYCOMMENTLIKE_USER1`
    FOREIGN KEY (`USER_idUSER`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MESSAGE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `twitter_DB`.`MESSAGE` (
  `idMESSAGE` INT NOT NULL,
  `Sender` VARCHAR(20) NOT NULL,
  `Recipient` VARCHAR(20) NOT NULL,
  `TEXT` VARCHAR(45) NULL,
  `DATE` TIMESTAMP NULL,
  PRIMARY KEY (`idMESSAGE`),
  INDEX `fk_MESSAGE_USER1_idx` (`Sender` ASC) VISIBLE,
  INDEX `fk_MESSAGE_USER2_idx` (`Recipient` ASC) VISIBLE,
  CONSTRAINT `fk_MESSAGE_USER1`
    FOREIGN KEY (`Sender`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MESSAGE_USER2`
    FOREIGN KEY (`Recipient`)
    REFERENCES `mydb`.`USER` (`idUSER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
