SELECT *
FROM room as r, roombooking as rb, hotel as h, hotelbooking as hb
where r."idHotel" = h."idHotel" and rb."roomID"= r."idRoom" and rb."hotelbookingID" = hb."idhotelbooking"
ORDER by h.city;

-- hotel booking ID -> 2737 gia idhotel 73 manager 2496

-- hotel booking ID -> 5167 gia idhotel 73 reception 2721

-- hotel booking ID -> 5167 gia idhotel 73 reception 2721

UPDATE hotelbooking SET payed = true 
where "idhotelbooking" = 2737 ;


UPDATE hotelbooking SET reservationdate = '2021-05-11'
where "idhotelbooking" = 2737 ;



UPDATE hotelbooking SET cancellationdate = '2021-05-10'
where "idhotelbooking" = 105 ;

SELECT * from hotelbooking 
where idhotelbooking = 2737;


SELECT * 
FROM employee as emp
where emp."hotelID" = 73;


insert into "Manages"
Values (2496,2737);

SELECT * 
FROM employee
where employee."idEmployee" = 2496

insert into "Manages"
Values (2721,5167);

SELECT * FROM "Manages";

SELECT * 
FROM roombooking as  rb 
where "hotelbookingID" = 105 ;

SELECT *
FROM roomrate, roombooking, room
where roombooking."hotelbookingID" = 105 and room."idRoom" = roombooking."hotelbookingID" 
and room."idHotel" = roomrate."idHotel" and room."roomtype"= roomrate."roomtype" ;


DELETE FROM roombooking 
where "hotelbookingID" = 105 and "roomID" = 40;

SELECT * 
FROM roombooking as  rb 
where "roomID" = 40;

INSERT INTO roombooking ("hotelbookingID", "roomID")
VALUES (105, 40 );

insert into "Manages"
Values (2496,105)  
RETURNING ;


INSERT INTO roombooking ("hotelbookingID", "roomID", "bookedofpersonID" ,"ckeckin", "ckeckout")
VALUES (105, 40, 6909, 2021-05-16, 2021-05-20);

INSERT INTO roombooking 
VALUES (105, 40, 6009, '2021-07-16', '2021-07-20', 50);

UPDATE roombooking SET checkout = '2021-07-20'
 where "hotelbookingID" = 105 and "roomID" = 40;
 ;


UPDATE hotelbooking SET totalamount =   50 * (DATE_PART('day', '2024-07-20'::timestamp - '2024-07-16'::timestamp))
where hotelbooking."idhotelbooking" = 105

UPDATE hotelbooking SET totalamount = null
where hotelbooking."idhotelbooking" = 105

SELECT * 
FROM hotelbooking 
where hotelbooking."idhotelbooking" = 105;



SELECT 
    CASE 
        WHEN EXISTS(
             SELECT totalamount 
             FROM  hotelbooking
             WHERE hotelbooking."idhotelbooking" = 105
			)
        THEN 'taken' -- 'NOT ALL'

        ELSE 'free' -- 'ALL'
    END

  SELECT DATE_PART('day', '2011-12-31 01:00:00'::timestamp - '2011-12-29 23:00:00'::timestamp);
  
SELECT * from hotelbooking 
where idhotelbooking = 105;


SELECT 
    CASE 
        WHEN EXISTS(
             SELECT * 
             FROM  roombooking as roombooking_0 
             WHERE  roombooking_0."roomID" = 40 and ( ('2022-06-13' <= roombooking_0.checkout and '2022-06-13' >= roombooking_0.checkin )
				or ('2022-06-12' >= roombooking_0.checkin and '2022-06-12' <= roombooking_0.checkout)  or 
				('2022-06-13' >= roombooking_0.checkout  and  '2022-06-12' <= roombooking_0.checkout)  or 
				('2022-06-13' >= roombooking_0.checkin  and  '2022-06-12' <= roombooking_0.checkin)  )
			)
        THEN 'taken' -- 'NOT ALL'

        ELSE 'free' -- 'ALL'
    END


SELECT *,DATE_PART('day', roombooking_0.checkin::timestamp -  '2021-01-15' ::timestamp)
FROM  roombooking as roombooking_0 
WHERE  roombooking_0."roomID" = 40 and  '2021-01-15'::date  < roombooking_0.checkin  and roombooking_0.checkin > '2021-01-12'


SELECT MIN (roombooking_0.checkin)
FROM  roombooking as roombooking_0 
WHERE  roombooking_0."roomID" = 40 and  '2021-01-15'::date  < roombooking_0.checkin  and roombooking_0.checkin > '2021-01-12'


MIN( )
DATE_PART('day', new.checkout::timestamp - new.checkin ::timestamp)





CREATE TRIGGER "5_3_trigger_room_booking"
BEFORE INSERT OR UPDATE OR DELETE ON roombooking  
FOR EACH ROW EXECUTE PROCEDURE "5_3_process_room_booking"();



CREATE OR REPLACE FUNCTION "5_3_process_room_booking"() RETURNS TRIGGER AS $$
DECLARE role_0 character varying(45);
DECLARE rate_0 real;
DECLARE discount_0 real;
DECLARE free_0 integer;
DECLARE total_amount real;
DECLARE hotel_book integer;
DECLARE maximum_checkout date;
DECLARE cancel_date date;
BEGIN

IF (TG_OP = 'DELETE') THEN
	-- Get cancellationdate for delete operation
	SELECT cancellationdate into cancel_date
	FROM hotelbooking 
	WHERE hotelbooking."idhotelbooking" = old."hotelbookingID";
	-- If cancel date has not passed, we can delete
	IF (cancel_date >= (NOW()::date)  ) THEN
		SELECT totalamount into total_amount
        FROM  hotelbooking
        WHERE hotelbooking."idhotelbooking" = old."hotelbookingID";
		IF total_amount IS NULL THEN 
			total_amount = 0;
		END IF;
		UPDATE hotelbooking SET totalamount =  total_amount - old.rate * (DATE_PART('day', old.checkout::timestamp - old.checkin ::timestamp))
		where hotelbooking."idhotelbooking" = old."hotelbookingID";
		RETURN OLD;
	ELSE --( Cancel date has passed!)
		RAISE NOTICE ' You can not cancel after the cancellation date';	
		RETURN NULL;
	END IF;
ELSIF (TG_OP = 'UPDATE') THEN
	-- Checking if the room is available for x days after the old checkout
	SELECT into free_0
    CASE 
        WHEN EXISTS(
             SELECT * 
             FROM  roombooking as roombooking_0 
             WHERE  roombooking_0."roomID" = new."roomID" and ( (new.checkout <= roombooking_0.checkout and new.checkout  >= roombooking_0.checkin )
				or (old.checkout >= roombooking_0.checkin and old.checkout < roombooking_0.checkout)  or 
				(new.checkout  >= roombooking_0.checkout  and  old.checkout < roombooking_0.checkout)  or 
				(new.checkout  >= roombooking_0.checkin  and  old.checkout <= roombooking_0.checkin)  )
			)
        THEN 0 -- 'taken'
        ELSE 1 -- 'free'
    END;
	-- Calculating the last date that the room is available
	SELECT MIN (roombooking_0.checkin) into maximum_checkout
	FROM  roombooking as roombooking_0 
	WHERE  roombooking_0."roomID" = old."roomID" and  old.checkout < roombooking_0.checkin ;
	RAISE NOTICE ' Maximum checkout is = % ', maximum_checkout ;
	-- If the room is not available and we want more dates for the room
	-- we get nothing
	IF free_0 = 0  and (old.checkout < new.checkout )THEN
		RAISE NOTICE 'No availability';
		RETURN NULL;
	ELSE
		
		SELECT roomrate.rate, roomrate.discount INTO rate_0, discount_0
		FROM roomrate, roombooking, room
		where roombooking."hotelbookingID" = NEW."hotelbookingID" and room."idRoom" = roombooking."hotelbookingID" 
		and room."idHotel" = roomrate."idHotel" and room."roomtype"= roomrate."roomtype"
		GROUP BY roomrate.rate, roomrate.discount;
		-- Calculating the new rate by using distinct rate and discount
    	NEW.rate = rate_0 - rate_0*discount_0/100;
		SELECT totalamount into total_amount
        FROM  hotelbooking
        WHERE hotelbooking."idhotelbooking" = NEW."hotelbookingID";
		-- If the total_amount is NULL we can not add the rate to IT
		-- so if it is null, it gets initialized to ZERO
		IF total_amount IS NULL THEN 
			total_amount = 0;
		END IF;
		--As the hotelbooking trigger is already enabled, 
		UPDATE hotelbooking SET totalamount =  total_amount + NEW.rate * (DATE_PART('day', new.checkout::timestamp - old.checkout ::timestamp))
		where hotelbooking."idhotelbooking" = NEW."hotelbookingID";
		GET DIAGNOSTICS hotel_book = ROW_COUNT;
		-- checking if the update on room booking can be made by triggering hotelbooking
		-- if no updated rows on hotel booking, no update on the room booking too
		IF hotel_book = 0 THEN 
		  RAISE NOTICE 'This change can not be made';
		  RETURN NULL;
		ELSE 
			RETURN new;
		END IF;
	END IF;
ELSIF (TG_OP = 'INSERT') THEN
	-- Calculating the new rate for the newly inserted room booking
	SELECT roomrate.rate, roomrate.discount INTO rate_0, discount_0
	FROM roomrate, roombooking, room
	where roombooking."hotelbookingID" = NEW."hotelbookingID" and room."idRoom" = roombooking."hotelbookingID" 
	and room."idHotel" = roomrate."idHotel" and room."roomtype"= roomrate."roomtype"
	GROUP BY roomrate.rate, roomrate.discount;
	
    NEW.rate = rate_0 - rate_0*discount_0/100;
	-- Checking if the room is available for the requested dates.
	-- This was NOT requested but we also used in Update 
	SELECT into free_0
    CASE 
        WHEN EXISTS(
             SELECT * 
             FROM  roombooking as roombooking_0 
             WHERE  roombooking_0."roomID" = new."roomID" and ( (new.checkout <= roombooking_0.checkout and new.checkout  >= roombooking_0.checkin )
				or (new.checkin >= roombooking_0.checkin and new.checkin  <= roombooking_0.checkout)  or 
				(new.checkout  >= roombooking_0.checkout  and  new.checkin  <= roombooking_0.checkout)  or 
				(new.checkout  >= roombooking_0.checkin  and  new.checkin  <= roombooking_0.checkin)  )
			)
        THEN 0 -- 'taken'
        ELSE 1 -- 'free'
    END;
	IF free_0 = 0 THEN 
		RETURN NULL;
	ELSE
	    SELECT totalamount into total_amount
        FROM  hotelbooking
        WHERE hotelbooking."idhotelbooking" = NEW."hotelbookingID";
		IF total_amount IS NULL THEN 
			total_amount = 0;
		end if;
		UPDATE hotelbooking SET totalamount =  total_amount + NEW.rate * (DATE_PART('day', new.checkout::timestamp - new.checkin ::timestamp))
		where hotelbooking."idhotelbooking" = NEW."hotelbookingID";
		RETURN NEW;
	END IF;
END IF;
RETURN NULL; -- when NO return new , return null is needed 
END;
$$ LANGUAGE plpgsql;