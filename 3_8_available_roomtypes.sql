CREATE FUNCTION "3_8_available_roomtypes"() 

RETURNS table("Hotels" integer)
							 AS
$BODY$
BEGIN
RETURN QUERY
	SELECT table1."idHotel" 
	FROM (SELECT COUNT ("idHotel") as count1, "idHotel" -- i count how many roomtypes has available tonight for each hotel 
	  	FROM (SELECT "idHotel" --i kept the roomtypes that appears only once at each hotel
				FROM (SELECT "idHotel", roomtype, "idRoom" FROM room --i found all the rooms and roomtypes at each hotel
					  GROUP BY "idHotel", roomtype, "idRoom" 
				  	EXCEPT                                         --and i subtracked with no available rooms tonight
				  	SELECT "idHotel", roomtype, "idRoom"  FROM roombooking, room 
				  	WHERE roombooking."roomID" = room."idRoom"
							and ((SELECT CURRENT_DATE ) < roombooking.checkout and (SELECT CURRENT_DATE )> roombooking.checkin)
				  	GROUP BY "idHotel", roomtype, "idRoom") as booked
				GROUP BY booked."idHotel", booked.roomtype) as booked1
	   	GROUP BY booked1."idHotel") as table1 
	INNER JOIN (SELECT COUNT("idHotel") as count2, "idHotel"  -- i count how many roomtypes has each hotel
				FROM (SELECT "idHotel" FROM room --i found all the roomtypes at each hotel
				 	 GROUP BY "idHotel", roomtype) as query1 
				GROUP BY query1."idHotel") as table2 
	ON table1.count1 = table2.count2 and table1."idHotel" = table2."idHotel" -- keep every hotel that has 
	ORDER BY table1."idHotel";                                               --count of available roomtypes = count of all roomtypes by each hotel

--To sum up i find how many roomtypes are available tonight for each hotel 
--and compare them with all the roomtypes of each hotel
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "3_8_available_roomtypes"();

----query
SELECT table1."idHotel" 
FROM (SELECT COUNT ("idHotel") as count1, "idHotel" -- i count how many roomtypes has available tonight for each hotel 
	  FROM (SELECT "idHotel" --i kept the roomtypes that appears only once at each hotel
			FROM (SELECT "idHotel", roomtype, "idRoom" FROM room --i found all the rooms and roomtypes at each hotel
				  GROUP BY "idHotel", roomtype, "idRoom" 
				  EXCEPT                                         --and i subtracked with no available rooms tonight
				  SELECT "idHotel", roomtype, "idRoom"  FROM roombooking, room 
				  WHERE roombooking."roomID" = room."idRoom"
						and ((SELECT CURRENT_DATE ) < roombooking.checkout and (SELECT CURRENT_DATE )> roombooking.checkin)
				  GROUP BY "idHotel", roomtype, "idRoom") as booked
			GROUP BY booked."idHotel", booked.roomtype) as booked1
	   GROUP BY booked1."idHotel") as table1 
INNER JOIN (SELECT COUNT("idHotel") as count2, "idHotel"  -- i count how many roomtypes has each hotel
			FROM (SELECT "idHotel" FROM room --i found all the roomtypes at each hotel
				  GROUP BY "idHotel", roomtype) as query1 
			GROUP BY query1."idHotel") as table2 
ON table1.count1 = table2.count2 and table1."idHotel" = table2."idHotel" -- keep every hotel that has 
ORDER BY table1."idHotel"; 