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
where "idhotelbooking" = 2737 ;

SELECT * from hotelbooking 
where idhotelbooking = 2737;


SELECT * 
FROM employee as emp
where emp."hotelID" = 73;


insert into "Manages"
Values (2496,2737);

insert into "Manages"
Values (2721,5167);

SELECT * FROM "Manages";

SELECT NOW()::date;

DELETE  FROM hotelbooking  where idhotelbooking = 5167;

15 May 2021

SELECT "role" from "Manages" as man INNER JOIN employee as emp 
ON man."employee_idEmployee" = emp."idEmployee"
where man.hotelbooking_idhotelbooking = 2737 ;  

DROP trigger "5_2_trigger_booking_update"  on hotelbooking;

CREATE TRIGGER "5_2_trigger_booking_update"
BEFORE UPDATE OR DELETE ON hotelbooking  
FOR EACH ROW EXECUTE PROCEDURE "5_2_process_booking_update"();

CREATE TRIGGER "5_2_trigger_room_booking_update"
BEFORE UPDATE OR DELETE ON roombooking  
FOR EACH ROW EXECUTE PROCEDURE "5_2_process_booking_update"();




CREATE OR REPLACE FUNCTION "5_2_process_booking_update"() RETURNS TRIGGER AS $$

DECLARE role_0 character varying(45);
BEGIN

SELECT "role" INTO role_0 
from "Manages" as man INNER JOIN employee as emp ON man."employee_idEmployee" = emp."idEmployee"
where man.hotelbooking_idhotelbooking = OLD."idhotelbooking";

IF (TG_OP = 'DELETE') THEN
	IF (role_0 = 'manager') THEN 
		IF (OLD.cancellationdate >= (NOW()::date)  ) THEN
		-- The cancellation date has not passed, so manager can delete
			RETURN new; 
		END IF;
	ELSIF (role_0 = 'reception') THEN
		IF (OLD.cancellationdate >= (NOW()::date)  ) THEN
		-- The cancellation date has not passed,  so manager can delete
			RETURN new;
		END IF;
	END if; 
ELSIF (TG_OP = 'UPDATE') THEN
	IF (role_0 = 'manager') THEN 
		IF (OLD.cancellationdate >= (NOW()::date)  ) THEN
		-- The cancellation date has not passed, so everything can change
			RETURN NEW;
		ELSIF (NEW.cancellationdate != OLD.cancellationdate) and (OLD.reservationdate = NEW.reservationdate) and (OLD."bookedbyclientID" = NEW."bookedbyclientID") and (OLD.totalamount>= NEW.totalamount) THEN
		-- The manager can  update cancellation date , payed, paymethod, status	and total amount  but he 
		-- can NOT update reservationdate and bookedbyclient id
			RETURN NEW;
		ELSIF (OLD.reservationdate = NEW.reservationdate) and (OLD."bookedbyclientID" = NEW."bookedbyclientID") and (OLD.totalamount>= NEW.totalamount)  THEN 
			RETURN NEW;
		ELSE  
			RETURN NULL;
		END IF;
	ELSIF (role_0 = 'reception') THEN 
		IF (OLD.cancellationdate = New.cancellationdate  ) THEN
			IF (OLD.cancellationdate >= (NOW()::date)  ) THEN
			-- The cancellation date has not passed and it is NOT change, so reception can update
				RETURN NEW;
			ELSIF (OLD.reservationdate = NEW.reservationdate) and (OLD."bookedbyclientID" = NEW."bookedbyclientID") and (OLD.totalamount>= NEW.totalamount) THEN
			-- The cancellation date has passed, so reception can update payed, paymethod, status and total amount
				RETURN new;
			END IF;
		END if;
	END IF;
END IF;
RETURN NULL; -- when NO return new , return null is needed 
END;
$$ LANGUAGE plpgsql;

