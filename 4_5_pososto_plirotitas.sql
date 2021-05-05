
SELECT COUNT("idRoom")
FROM hotel as hotel_0 , room as room_0
WHERE hotel_0."idHotel" = room_0."idHotel" and  hotel_0."idHotel" = 11;

SELECT query2.month_1, count(distinct ("roomID"))/41.0*100 
FROM (SELECT * FROM roombooking as roombooking_0
INNER JOIN room as room_0 
ON roombooking_0."roomID" = room_0."idRoom" and room_0."idHotel" = 11
WHERE extract ('year' from (roombooking_0.checkin)) = 2021) as query1 JOIN (SELECT
extract ('month' from (roombooking_0.checkin) ) as month_1, COUNT(DISTINCT (roombooking_0."roomID")) 
FROM roombooking as roombooking_0
INNER JOIN room as room_0 
ON roombooking_0."roomID" = room_0."idRoom" and room_0."idHotel" = 11
WHERE extract ('year' from (roombooking_0.checkin)) = 2021 
and extract ('month' from (roombooking_0.checkin) ) <= extract ('month' from (roombooking_0.checkout) )
GROUP BY month_1 ) as query2 
ON query2.month_1 >= extract ('month' from (query1.checkin) ) and query2.month_1<= extract ('month' from (query1.checkout) )
GROUP BY query2.month_1 ;






CREATE FUNCTION "4_5_calculate_plirotita"(hotel_in integer, year_in integer) 

RETURNS table("Month" double precision, Plirotita double precision)
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
WHERE extract ('year' from (roombooking_0.checkin)) = year_in) as query1 JOIN (SELECT
extract ('month' from (roombooking_0.checkin) ) as month_1, COUNT(DISTINCT (roombooking_0."roomID")) 
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

SELECT * FROM "4_5_calculate_plirotita"(11, 2021);





























--- MALLON AXRISTA ALLA ISOS KAPOU XRISIMA
SELECT test2.month_0,test2.checkinmonth,test2.checkoutmonth, 
CASE WHEN test2.checkinmonth > test2.checkoutmonth THEN test2.checkinmonth
WHEN test2.checkinmonth <= test2.checkoutmonth THEN test2.checkoutmonth 
END AS finalmonth
FROM (
SELECT month_0, checkinmonth,checkoutmonth 
FROM (
SELECT
 extract ('month' from (roombooking_0.checkin) ) as month_0, COUNT(DISTINCT (roombooking_0."roomID")) as checkinmonth
FROM roombooking as roombooking_0
INNER JOIN room as room_0 
ON roombooking_0."roomID" = room_0."idRoom" and  room_0."idHotel" = 11
WHERE extract ('year' from (roombooking_0.checkin)) = 2021 
GROUP BY month_0
	) as test1
FULL  JOIN (
SELECT
 extract ('month' from (roombooking_1.checkout) ) as month_1, COUNT(DISTINCT (roombooking_1."roomID")) as checkoutmonth
FROM roombooking as roombooking_1
INNER JOIN room as room_1 
ON roombooking_1."roomID" = room_1."idRoom" and  room_1."idHotel" = 11
WHERE extract ('year' from (roombooking_1.checkout)) = 2021 
GROUP BY month_1
) as test0
ON test0.month_1 = test1.month_0
	) as test2
;




SELECT *
FROM (SELECT * FROM roombooking as roombooking_0
INNER JOIN room as room_0 
ON roombooking_0."roomID" = room_0."idRoom" and room_0."idHotel" = 11
WHERE extract ('year' from (roombooking_0.checkin)) = 2021) as query1 JOIN (SELECT
extract ('month' from (roombooking_0.checkin) ) as month_1, COUNT(DISTINCT (roombooking_0."roomID")) 
FROM roombooking as roombooking_0
INNER JOIN room as room_0 
ON roombooking_0."roomID" = room_0."idRoom" and room_0."idHotel" = 11
WHERE extract ('year' from (roombooking_0.checkin)) = 2021 
and extract ('month' from (roombooking_0.checkin) ) <= extract ('month' from (roombooking_0.checkout) )
GROUP BY month_1 ) as query2 
ON query2.month_1 >= extract ('month' from (query1.checkin) ) 
and query2.month_1<= extract ('month' from (query1.checkout) )
-- GROUP BY query2.month_1 ;