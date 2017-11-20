DROP DATABASE IF EXISTS VirtualChipDB;
CREATE DATABASE VirtualChipDB;

USE VirtualChipDB;

CREATE TABLE Users (
	userID INT(11) PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(20) NOT NULL,
    password_str VARCHAR(20) NOT NULL,
	gamesPlayed INT(11) NOT NULL,
    winnings INT(11) NOT NULL,
    losses INT(11) NOT NULL,
    roundsPlayed INT(11) NOT NULL,
    roundsWon INT(11) NOT NULL
);

