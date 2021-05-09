CREATE FUNCTION "4_4_bigger_totalamounts"() 
RETURNS table("idhotel" integer, "City" character varying (45))
							 AS
$BODY$
BEGIN
RETURN QUERY
	SELECT DISTINCT(table1."idHotel"), table1.city FROM (SELECT DISTINCT (transactio."idTransaction"), transactio.amount, hotel.city, hotel."idHotel" FROM room as room, roombooking as roombooking, hotel as hotel, "Transaction" as transactio
           WHERE transactio.idhotelbooking = roombooking."hotelbookingID" 
           and roombooking."roomID" = room."idRoom" and room."idHotel" = hotel."idHotel") as table1
           INNER JOIN (SELECT avg(query1.amount), city FROM (SELECT DISTINCT (transactio."idTransaction"), transactio.amount, hotel.city FROM room as room, roombooking as roombooking, hotel as hotel, "Transaction" as transactio
                 WHERE transactio.idhotelbooking = roombooking."hotelbookingID" 
                 and roombooking."roomID" = room."idRoom" and room."idHotel" = hotel."idHotel") as query1
                 GROUP BY query1.city) as table2 
            ON table1.city = table2.city and table2.avg < table1.amount;
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "4_4_bigger_totalamounts"();
------query

SELECT DISTINCT (transactio."idTransaction"), transactio.amount, hotel.city, hotel."idHotel" FROM room as room, roombooking as roombooking, hotel as hotel, "Transaction" as transactio
WHERE transactio.idhotelbooking = roombooking."hotelbookingID" 
and roombooking."roomID" = room."idRoom" and room."idHotel" = hotel."idHotel";

SELECT avg(query1.amount), city FROM (SELECT DISTINCT (transactio."idTransaction"), transactio.amount, hotel.city FROM room as room, roombooking as roombooking, hotel as hotel, "Transaction" as transactio
WHERE transactio.idhotelbooking = roombooking."hotelbookingID" 
and roombooking."roomID" = room."idRoom" and room."idHotel" = hotel."idHotel") as query1
GROUP BY query1.city;

SELECT DISTINCT(table1."idHotel"), table1.city FROM (SELECT DISTINCT (transactio."idTransaction"), transactio.amount, hotel.city, hotel."idHotel" FROM room as room, roombooking as roombooking, hotel as hotel, "Transaction" as transactio
WHERE transactio.idhotelbooking = roombooking."hotelbookingID" 
and roombooking."roomID" = room."idRoom" and room."idHotel" = hotel."idHotel") as table1
INNER JOIN (SELECT avg(query1.amount), city FROM (SELECT DISTINCT (transactio."idTransaction"), transactio.amount, hotel.city FROM room as room, roombooking as roombooking, hotel as hotel, "Transaction" as transactio
WHERE transactio.idhotelbooking = roombooking."hotelbookingID" 
and roombooking."roomID" = room."idRoom" and room."idHotel" = hotel."idHotel") as query1
GROUP BY query1.city) as table2 
ON table1.city = table2.city and table2.avg < table1.amount;