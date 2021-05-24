CREATE FUNCTION "3_4_reservations_by"(hotel integer)
RETURNS TABLE("IDhotelbooking" integer, "Fname" character varying(45), "Lname" character varying(45), "ReservationDate" date, "bookedBy" text) AS 
$BODY$
BEGIN
RETURN QUERY
	SELECT idhotelbooking, fname, lname, reservationdate, 
		(SELECT CASE WHEN query2."hotelbooking_idhotelbooking" IS NULL THEN 'client' ELSE 'employee' END) as bookedby
	FROM (SELECT DISTINCT(hotelbooking_0.idhotelbooking), person_0.fname, person_0.lname,hotelbooking_0.reservationdate
			FROM room as room_0 , roombooking as roombooking_0 , hotelbooking as hotelbooking_0, client as client_0, person as person_0
			WHERE room_0."idHotel" = $1 and room_0."idRoom" = roombooking_0."roomID"
				and roombooking_0."hotelbookingID" = hotelbooking_0."idhotelbooking" and
				client_0."idClient" = hotelbooking_0."bookedbyclientID" and person_0."idPerson" = client_0."idClient") as query1 
	LEFT JOIN (SELECT "hotelbooking_idhotelbooking"
           	FROM room as room_0 , roombooking as roombooking_0 , 
				hotelbooking as hotelbooking_0, "Manages" as manages
           	WHERE room_0."idHotel" = $1 and room_0."idRoom" = roombooking_0."roomID"
           		and roombooking_0."hotelbookingID" = hotelbooking_0."idhotelbooking" 
			    and hotelbooking_0."idhotelbooking" = manages."hotelbooking_idhotelbooking"
		   	GROUp BY manages."hotelbooking_idhotelbooking") as query2
	ON query1.idhotelbooking = query2."hotelbooking_idhotelbooking";
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "3_4_reservations_by"(105);

------query
SELECT DISTINCT(hotelbooking_0.idhotelbooking), person_0.fname, person_0.lname,
hotelbooking_0.reservationdate
FROM room as room_0 , roombooking as roombooking_0 , 
hotelbooking as hotelbooking_0, client as client_0, person as person_0
WHERE room_0."idHotel" = 105 and room_0."idRoom" = roombooking_0."roomID"
and roombooking_0."hotelbookingID" = hotelbooking_0."idhotelbooking" and
client_0."idClient" = hotelbooking_0."bookedbyclientID" and 
person_0."idPerson" = client_0."idClient" ;


SELECT "hotelbooking_idhotelbooking"
             FROM room as room_0 , roombooking as roombooking_0 , 
				hotelbooking as hotelbooking_0, "Manages" as manages
             WHERE room_0."idHotel" = 105 and room_0."idRoom" = roombooking_0."roomID"
             and roombooking_0."hotelbookingID" = hotelbooking_0."idhotelbooking" 
			 and hotelbooking_0."idhotelbooking" = manages."hotelbooking_idhotelbooking"
			 GROUp BY manages."hotelbooking_idhotelbooking"

(SELECT CASE WHEN query2."hotelbooking_idhotelbooking" IS NULL THEN 'client' ELSE 'employee' END) as bookedby