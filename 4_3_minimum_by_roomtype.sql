CREATE FUNCTION "4_3_minimum_by_roomtype"(country_1 character varying(45)) 

RETURNS table("CITY" character varying(45), Minimum double precision)
							 AS
$BODY$
BEGIN
RETURN QUERY
	SELECT test2.city, test1.minimum FROM (SELECT query1.roomtype, min(query1.total_price) as minimum FROM (SELECT roomtype, roomrate_0."idHotel", city, (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) as total_price
    FROM  hotel as hotel_0 INNER JOIN roomrate as roomrate_0
	ON hotel_0."idHotel" = roomrate_0."idHotel"  
	WHERE hotel_0.country = $1) as query1
	GROUP BY query1.roomtype) as test1 JOIN (SELECT roomtype, roomrate_0."idHotel", city, (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) as total_price
    FROM  hotel as hotel_0 INNER JOIN roomrate as roomrate_0
	ON hotel_0."idHotel" = roomrate_0."idHotel"  
	WHERE hotel_0.country = $1) as test2 
	ON test1.roomtype = test2.roomtype and test1.minimum = test2.total_price
	ORDER BY test1.minimum;
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "4_3_minimum_by_roomtype"('Russia');

--------query 

SELECT test2.city, test1.minimum FROM (SELECT query1.roomtype, min(query1.total_price) as minimum FROM (SELECT roomtype, roomrate_0."idHotel", city, (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) as total_price
    FROM  hotel as hotel_0 INNER JOIN roomrate as roomrate_0
	ON hotel_0."idHotel" = roomrate_0."idHotel"  
	WHERE hotel_0.country = 'Russia') as query1
	GROUP BY query1.roomtype) as test1 JOIN (SELECT roomtype, roomrate_0."idHotel", city, (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) as total_price
    FROM  hotel as hotel_0 INNER JOIN roomrate as roomrate_0
	ON hotel_0."idHotel" = roomrate_0."idHotel"  
	WHERE hotel_0.country = 'Russia') as test2 
	ON test1.roomtype = test2.roomtype and test1.minimum = test2.total_price