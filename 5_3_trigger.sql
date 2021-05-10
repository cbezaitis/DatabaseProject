SELECT * 
FROM roombooking as  rb 
where "hotelbookingID" = 105 ;

DELETE FROM roombooking 
where "hotelbookingID" = 105 and "roomID" = 40 ;

INSERT INTO roombooking ("hotelbookingID", "roomID")
VALUES (105,40)


CREATE TRIGGER "5_3_trigger_room_booking"
BEFORE INSERT OR UPDATE OR DELETE ON roombooking  
FOR EACH ROW EXECUTE PROCEDURE "5_3_process_room_booking"();



CREATE OR REPLACE FUNCTION "5_3_process_room_booking"() RETURNS TRIGGER AS $$
DECLARE role_0 character varying(45);
DECLARE rate   real;
BEGIN


SELECT "role" INTO role_0 
from "Manages" as man INNER JOIN employee as emp ON man."employee_idEmployee" = emp."idEmployee"
where man.hotelbooking_idhotelbooking = NEW."hotelbookingID";

-- Pao na upologiso to Rate tou roombooking apo to Roomrate 
-- Sinartisi i opoia tha pairnei to apoPano Rate mazi me check in, check out 

-- Edo leei oti opos pao kai kano update sto total amount tou hotel booking, 
-- ean epistrafei "0" , tote return null 
-- ean epistrafei "1",  tote return new

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
ELSIF (TG_OP = 'INSERT') THEN
	NEW.rate = 789;
	RETURN NEW;
END IF;
RETURN NULL; -- when NO return new , return null is needed 
END;
$$ LANGUAGE plpgsql;
