CREATE FUNCTION "3_1_searchCityCountryDiscount"()
RETURNS TABLE("CITY" character varying(45), "COUNTRY" character varying(45)) AS 
$BODY$
BEGIN
RETURN QUERY
	SELECT DISTINCT(city), country 
	FROM hotel as hotel_0,roomrate as roomrate_0
	where roomrate_0.discount >= 30 and hotel_0."idHotel" = roomrate_0."idHotel";
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "3_1_searchCityCountryDiscount"();