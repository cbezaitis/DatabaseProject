CREATE FUNCTION "4_2_average_by_roomtype"() 

RETURNS table("ROOM_TYPE" character varying(45), Average double precision)
							 AS
$BODY$
BEGIN
RETURN QUERY
	SELECT query1.roomtype, avg(query1.date_part) FROM (SELECT room.roomtype, date_part('year',age(person.dateofbirth)) FROM room as room 
    INNER JOIN roombooking as book 
	ON room."idRoom" = book."roomID"
	    INNER JOIN person as person 
		ON person."idPerson" = book."bookedforpersonID") as query1
		GROUP BY query1.roomtype;
END
$BODY$ LANGUAGE plpgsql;
	
SELECT * FROM "4_2_average_by_roomtype"();


-----query
SELECT query1.roomtype, avg(query1.date_part) FROM (SELECT room.roomtype, date_part('year',age(person.dateofbirth)) FROM room as room 
    INNER JOIN roombooking as book 
	ON room."idRoom" = book."roomID"
	    INNER JOIN person as person 
		ON person."idPerson" = book."bookedforpersonID") as query1
		GROUP BY query1.roomtype;