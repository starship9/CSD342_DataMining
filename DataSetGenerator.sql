CREATE PROCEDURE InsertRand(IN NumRows INT, IN MinVal INT, IN MaxVal INT)
BEGIN
DECLARE i INT;
SET i = 1;
START TRANSACTION;
WHILE i <= NumRows DO
INSERT IGNORE INTO rand_numbers VALUES ((MinVal + CEIL(RAND() * (MaxVal - MinVal))),(MinVal + CEIL(RAND() * (MaxVal - MinVal))));
SET i = i + 1;
END WHILE;
COMMIT;
END$$
DELIMITER ;