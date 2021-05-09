CREATE FUNCTION "4_5_occupancy_rate"(hotel_in integer, year_in integer) 

RETURNS table("Month" double precision, "Rate" double precision)
							 AS
$BODY$
DECLARE number_of_rooms real; 

BEGIN

SELECT COUNT("idRoom")/100.0 INTO number_of_rooms
FROM hotel as hotel_0 , room as room_0
WHERE hotel_0."idHotel" = room_0."idHotel" and  hotel_0."idHotel" = hotel_in ;

RETURN QUERY
       SELECT query2.month_1 as "Month", count(distinct ("roomID"))/number_of_rooms as "PosostoPlirotitas"
       FROM (SELECT * FROM roombooking as roombooking_0
       INNER JOIN room as room_0 
       ON roombooking_0."roomID" = room_0."idRoom" and room_0."idHotel" = hotel_in
       WHERE extract ('year' from (roombooking_0.checkin)) = year_in) as query1  
	         JOIN (
		            SELECT extract ('month' from (roombooking_0.checkin) ) as month_1, COUNT(DISTINCT (roombooking_0."roomID")) 
                    FROM roombooking as roombooking_0
                         INNER JOIN room as room_0 
                         ON roombooking_0."roomID" = room_0."idRoom" and room_0."idHotel" = hotel_in
                          WHERE extract ('year' from (roombooking_0.checkin)) = year_in 
                               and extract ('month' from (roombooking_0.checkin) ) <= extract ('month' from (roombooking_0.checkout) )
                          GROUP BY month_1 ) as query2 
              ON query2.month_1 >= extract ('month' from (query1.checkin) ) and query2.month_1<= extract ('month' from (query1.checkout) )
              GROUP BY query2.month_1 ;
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "4_5_occupancy_rate"(11, 2021);
-----query
SELECT query2.month_1 as "Month", count(distinct ("roomID"))/number_of_rooms as "PosostoPlirotitas"
       FROM (SELECT * FROM roombooking as roombooking_0
       INNER JOIN room as room_0 
       ON roombooking_0."roomID" = room_0."idRoom" and room_0."idHotel" = hotel_in
       WHERE extract ('year' from (roombooking_0.checkin)) = year_in) as query1  
	         JOIN (
		            SELECT extract ('month' from (roombooking_0.checkin) ) as month_1, COUNT(DISTINCT (roombooking_0."roomID")) 
                    FROM roombooking as roombooking_0
                         INNER JOIN room as room_0 
                         ON roombooking_0."roomID" = room_0."idRoom" and room_0."idHotel" = hotel_in
                          WHERE extract ('year' from (roombooking_0.checkin)) = year_in 
                               and extract ('month' from (roombooking_0.checkin) ) <= extract ('month' from (roombooking_0.checkout) )
                          GROUP BY month_1 ) as query2 
              ON query2.month_1 >= extract ('month' from (query1.checkin) ) and query2.month_1<= extract ('month' from (query1.checkout) )
              GROUP BY query2.month_1 ;