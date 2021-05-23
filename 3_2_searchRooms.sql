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