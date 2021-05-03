CREATE FUNCTION 2_1_insert_card(documentcl character varying(45), card_type_1 character varying(45),
							 card_number_1 character varying(45), expiration_1 date, 
							 holder_1 character varying(45)) 
RETURNS table(card_type character varying(45), card_number character varying(45), expiration_date date, 
							 holder_name character varying(45), clientid integer) AS
$BODY$
DECLARE idpers integer;
BEGIN
SELECT "idClient" INTO idpers
FROM client 
WHERE documentclient=$1;
INSERT INTO creditcard(cardtype, "number", expiration, holder, "clientID") 
      VALUES ($2, $3, $4, $5, idpers);
RETURN QUERY
   SELECT *
   FROM creditcard 
   WHERE "clientID" = idpers;
END
$BODY$ LANGUAGE plpgsql;

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

CREATE FUNCTION "3_2_searchRooms"("hotelStars" character varying(10), "Name" character varying(45))
RETURNS TABLE("HOTEL" integer , "HotelName" character varying(45), "HotelStars" character varying(10), "Room" character varying(45), "RoomRate" real, "Roomdiscount" real, "Facility_1" character varying(45), "Facility_2" character varying(45)) AS 
$BODY$
BEGIN
RETURN QUERY
	SELECT  hotel_0."idHotel", hotel_0."name", hotel_0."stars", roomrate_0."roomtype", roomrate_0."rate", roomrate_0."discount" , hotelfacilities_0."nameFacility", hotelfacilities_1."nameFacility"   
	FROM hotel as hotel_0 INNER JOIN roomrate as roomrate_0 
	ON hotel_0."idHotel" = roomrate_0."idHotel"  
	   INNER JOIN hotelfacilities as hotelfacilities_0
	   ON hotel_0."idHotel" = hotelfacilities_0."idHotel" 
	       INNER JOIN hotelfacilities as hotelfacilities_1
		   ON hotel_0."idHotel" = hotelfacilities_1."idHotel"
	WHERE hotel_0."idHotel" = roomrate_0."idHotel" and hotelfacilities_0."nameFacility" = 'Restaurant' and hotelfacilities_1."nameFacility" = 'Breakfast'
	      and hotel_0.stars= $1 and roomrate_0.roomtype = 'Studio' and hotel_0.name like $2||'%' and  (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) < 80 ;
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "3_2_searchRooms"('3', '%');

	SELECT * 
	FROM hotel as hotel_0,roomrate as roomrate_0
	where hotel_0.stars= '3' and roomrate_0.roomtype = 'Studio' and hotel_0."idHotel" = roomrate_0."idHotel" 
	and hotel_0.name like 'Mad'||'%' ;
    
	SELECT * 
	FROM hotel as hotel_0,roomrate as roomrate_0 
	where (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) < 80;
	
	SELECT * 
	FROM hotel as hotel_0,roomrate as roomrate_0 
	where (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) < 80 and hotel_0."idHotel" = roomrate_0."idHotel";
	
	SELECT * 
	FROM hotel as hotel_0, roomrate as roomrate_0 , hotelfacilities as hotelfacilities_0, hotelfacilities as hotelfacilities_1
	WHERE hotelfacilities_0."nameFacility" = 'Restaurant' and hotelfacilities_1."nameFacility" = 'Breakfast'
	and hotel_0."idHotel" = hotelfacilities_0."idHotel" and  hotel_0."idHotel" = hotelfacilities_1."idHotel" ;
	
	
		SELECT * 
	FROM hotel as hotel_0, roomrate as roomrate_0 , hotelfacilities as hotelfacilities_0, hotelfacilities as hotelfacilities_1
	WHERE hotelfacilities_0."nameFacility" = 'Restaurant' and hotelfacilities_1."nameFacility" = 'Breakfast'
	and hotel_0."idHotel" = hotelfacilities_0."idHotel" and  hotel_0."idHotel" = hotelfacilities_1."idHotel" ;
	
		SELECT * 
	FROM hotel as hotel_0 INNER JOIN roomrate as roomrate_0 ON hotel_0."idHotel" = roomrate_0."idHotel" 
	where hotel_0.stars= '3' and roomrate_0.roomtype = 'Studio'
	and hotel_0.name like '%'||'%' and  (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) < 80 ;

	
		SELECT * 
	FROM hotel as hotel_0,roomrate as roomrate_0
	where hotel_0.stars= '3' and roomrate_0.roomtype = 'Studio' and hotel_0."idHotel" = roomrate_0."idHotel" 
	and hotel_0.name like '%'||'%' and  (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) < 80;
	

--Sosto
	SELECT * 
	FROM hotel as hotel_0, roomrate as roomrate_0 , hotelfacilities as hotelfacilities_0,
	hotelfacilities as hotelfacilities_1
	where hotel_0.stars= '3' and roomrate_0.roomtype = 'Studio' and hotel_0."idHotel" = roomrate_0."idHotel" 
	and hotel_0.name like '%'||'%' and  (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) < 80 and
	hotelfacilities_0."nameFacility" = 'Restaurant' and hotelfacilities_1."nameFacility" = 'Breakfast'
	and hotel_0."idHotel" = hotelfacilities_0."idHotel" and  hotel_0."idHotel" = hotelfacilities_1."idHotel";

SELECT * 
	FROM hotel as hotel_0 INNER JOIN roomrate as roomrate_0 
	ON hotel_0."idHotel" = roomrate_0."idHotel"  
	   INNER JOIN hotelfacilities as hotelfacilities_0
	   ON hotel_0."idHotel" = hotelfacilities_0."idHotel" 
	       INNER JOIN hotelfacilities as hotelfacilities_1
		   ON hotel_0."idHotel" = hotelfacilities_1."idHotel"
	WHERE hotel_0."idHotel" = roomrate_0."idHotel" and hotelfacilities_0."nameFacility" = 'Restaurant' and hotelfacilities_1."nameFacility" = 'Breakfast'
	      and hotel_0.stars= '3' and roomrate_0.roomtype = 'Studio' and hotel_0.name like '%'||'%' and  (roomrate_0.rate - roomrate_0.rate*roomrate_0.discount/100) < 80 ;;
