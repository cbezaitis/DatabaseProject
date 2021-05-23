CREATE OR REPLACE VIEW "6_1_rooms_availability_of_hotel_14" AS
SELECT "idRoom", roomtype, maximum_checkout 
FROM (SELECT "idRoom", roomtype FROM room WHERE room."idHotel"= 14
		EXCEPT
		SELECT "roomID", roomtype FROM roombooking, room 
		WHERE roombooking."roomID" = room."idRoom" and room."idHotel" = 14 
			and ((SELECT CURRENT_DATE ) < roombooking.checkout and (SELECT CURRENT_DATE )> roombooking.checkin)) as query1 
	INNER JOIN (SELECT "roomID", min(checkin) as maximum_checkout FROM roombooking, room 
		WHERE roombooking."roomID" = room."idRoom" and room."idHotel" = 14 
			and ((SELECT CURRENT_DATE ) < roombooking.checkin) GROUP BY roombooking."roomID") as query2
	ON query1."idRoom" = query2."roomID";

SELECT * FROM "6_1_rooms_availability_of_hotel_14";

CREATE OR REPLACE VIEW "6_1_rooms_availability_of_hotel_42" AS
SELECT "idRoom", roomtype, maximum_checkout 
FROM (SELECT "idRoom", roomtype FROM room WHERE room."idHotel"= 42
		EXCEPT
		SELECT "roomID", roomtype FROM roombooking, room 
		WHERE roombooking."roomID" = room."idRoom" and room."idHotel" = 42
			and ((SELECT CURRENT_DATE ) < roombooking.checkout and (SELECT CURRENT_DATE )> roombooking.checkin)) as query1 
	INNER JOIN (SELECT "roomID", min(checkin) as maximum_checkout FROM roombooking, room 
		WHERE roombooking."roomID" = room."idRoom" and room."idHotel" = 42 
			and ((SELECT CURRENT_DATE ) < roombooking.checkin) GROUP BY roombooking."roomID") as query2
	ON query1."idRoom" = query2."roomID";

SELECT * FROM "6_1_rooms_availability_of_hotel_42";

------query

SELECT "roomID" FROM roombooking, room 
WHERE roombooking."roomID" = room."idRoom" and room."idHotel" = 14 
	and ((SELECT CURRENT_DATE ) < roombooking.checkout and (SELECT CURRENT_DATE )> roombooking.checkin)
	ORDER BY roombooking.checkin


SELECT "roomID", min(checkin) FROM roombooking, room 
WHERE roombooking."roomID" = room."idRoom" and room."idHotel" = 14 
	and ((SELECT CURRENT_DATE ) < roombooking.checkin)
	GROUP BY roombooking."roomID"

SELECT "idRoom" FROM room WHERE room."idHotel"= 14