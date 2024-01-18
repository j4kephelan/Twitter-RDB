-- DROP DATABASE IF EXISTS Twitter_RDB;
-- CREATE DATABASE Twitter_RDB;
USE Twitter_RDB;

DROP TABLE IF EXISTS TWEET;
CREATE TABLE TWEET (
	tweet_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL, -- Foreign key to imaginary "USER" table (thus not enforced)
    tweet_ts DATETIME,
    tweet_text VARCHAR(140) NOT NULL
);

DROP TABLE IF EXISTS FOLLOWS;
CREATE TABLE FOLLOWS (
	user_id INT, -- Foreign key to imaginary "USER" table (thus not enforced)
    follows_id INT, -- Foreign key to imaginary "USER" table (thus not enforced)
    PRIMARY KEY (user_id, follows_id)
);

-- DEALLOCATE PREPARE tweet_insert;
-- PREPARE tweet_insert FROM 'INSERT INTO TWEET(user_id, tweet_ts, tweet_text) VALUES (?, NOW(), ?)';

DROP PROCEDURE IF EXISTS tweet_insert_procedure;
DELIMITER //
CREATE PROCEDURE tweet_insert_procedure
(
	py_user_id INT,
    py_tweet_text VARCHAR(140)
)
BEGIN
	SET @user_id = py_user_id;
    SET @tweet_text = py_tweet_text;
    
    PREPARE tweet_insert FROM 'INSERT INTO TWEET(user_id, tweet_ts, tweet_text) VALUES (?, NOW(), ?)';
    EXECUTE tweet_insert USING @user_id, @tweet_text;
END//
DELIMITER ;