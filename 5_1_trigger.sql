-- hotel booking ID -> 2737 gia idhotel 73 manager 2496

-- hotel booking ID -> 5167 gia idhotel 73 reception 2721

-- hotel booking ID -> 5167 gia idhotel 73 reception 2721

SElECT sum(amount) FROM "Transaction" WHERE idhotelbooking = 105 and "action"!='cancelation';

SElECT * FROM "Transaction" WHERE idhotelbooking = 105 and "action"!='cancelation';

SELECT totalamount FROM hotelbooking WHERE idhotelbooking = 105;

SELECT * FROM "Transaction" where idhotelbooking = 105 ;

UPDATE "Transaction" SET amount = 800 WHERE idhotelbooking = 105 and "idTransaction"=1;

UPDATE "Transaction" SET amount = 800 WHERE idhotelbooking = 105 and "idTransaction"=2;

DELETE FROM "Transaction" WHERE idhotelbooking = 105 and "idTransaction"=2;

INSERT INTO "Transaction" VALUES (1, 105,  '2021-05-10', 960, 'reservation');
INSERT INTO "Transaction" VALUES (2, 105,  '2021-05-10', 100, 'reservation');

UPDATE hotelbooking SET payed = true
where "idhotelbooking" = 105 ;

UPDATE hotelbooking SET cancellationdate = '2021-05-10'
where "idhotelbooking" = 105 ;

SELECT * from hotelbooking 
where idhotelbooking = 105;

CREATE TRIGGER "5_1_trigger_make_transaction"
AFTER INSERT OR UPDATE OR DELETE ON "Transaction"  
FOR EACH ROW EXECUTE PROCEDURE "5_1_process_make_transaction"();

CREATE OR REPLACE FUNCTION "5_1_process_make_transaction"() RETURNS TRIGGER AS $$
DECLARE total_amount real;
DECLARE amount_0 real;
BEGIN
--if trigger's by delete you have to use old
IF (TG_OP = 'DELETE') THEN --find the sum of transactions with id hotelbooking and the totalamount
	SElECT sum(amount) into amount_0 FROM "Transaction" WHERE idhotelbooking = old.idhotelbooking and "action"!='cancelation';
	SELECT totalamount into total_amount FROM hotelbooking WHERE idhotelbooking = old.idhotelbooking;
	IF (total_amount=amount_0) THEN 
		UPDATE hotelbooking SET payed = 'true' WHERE idhotelbooking = old.idhotelbooking;
	ELSEIF (total_amount>amount_0) THEN 
		UPDATE hotelbooking SET payed = 'false' WHERE idhotelbooking = old.idhotelbooking;
	ELSE --if totalamount is less than the amount you have given then hotel owes money to the client
    	UPDATE hotelbooking SET payed = 'true' WHERE idhotelbooking = old.idhotelbooking;
		RAISE NOTICE 'We owe % to the client!', amount_0 - total_amount;
	END IF;
ELSE --else you have to use new
	SElECT sum(amount) into amount_0 FROM "Transaction" WHERE idhotelbooking = new.idhotelbooking and "action"!='cancelation';
	SELECT totalamount into total_amount FROM hotelbooking WHERE idhotelbooking = new.idhotelbooking;
	IF (total_amount=amount_0) THEN 
		UPDATE hotelbooking SET payed = 'true' WHERE idhotelbooking = new.idhotelbooking;
	ELSEIF (total_amount>amount_0) THEN 
		UPDATE hotelbooking SET payed = 'false' WHERE idhotelbooking = new.idhotelbooking;
	ELSE --if totalamount is less than the amount you have given then hotel owes money to the client
    	UPDATE hotelbooking SET payed = 'true' WHERE idhotelbooking = new.idhotelbooking;
		RAISE NOTICE 'We owe % to the client!', amount_0 - total_amount;
	END IF;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;