CREATE OR REPLACE FUNCTION "3_7_search_by_facility"(hotel_facility character varying(45), room_facility character varying(45)) 

RETURNS TABLE(hotel integer, room integer)
							 AS
$BODY$
DECLARE facility_0 character varying(45);
BEGIN
RETURN QUERY 
	SELECT query1."idHotel", query1."idRoom" FROM (SELECT "idHotel", "idRoom" FROM room --i found all the rooms and roomtypes at each hotel
					GROUP BY "idHotel", roomtype, "idRoom" 
					EXCEPT                                         --and i subtracked with no available rooms tonight
					SELECT "idHotel", "idRoom"  FROM roombooking, room 
					WHERE roombooking."roomID" = room."idRoom"
						and ((SELECT CURRENT_DATE ) < roombooking.checkout and (SELECT CURRENT_DATE )> roombooking.checkin)
					GROUP BY "idHotel", roomtype, "idRoom") as query1, hotelfacilities, roomfacilities 
	WHERE query1."idHotel" = hotelfacilities."idHotel" and query1."idRoom" = roomfacilities."idRoom" 
		and (SELECT "helper_find_parent_facility"(hotelfacilities."nameFacility")) = (SELECT "helper_find_parent_facility"($1))
		and (SELECT "helper_find_parent_facility"(roomfacilities."nameFacility")) = (SELECT "helper_find_parent_facility"($2))
	GROUP BY query1."idHotel", query1."idRoom";
END;
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "3_7_search_by_facility"('Kids Services', 'Kid Amenities' ); 

------function helper finds parent facility
CREATE OR REPLACE FUNCTION helper_find_parent_facility(facility character varying(45)) 

RETURNS character varying(45)
							 AS
$BODY$
DECLARE facility_0 character varying(45);
BEGIN
WITH recursive cat_tree as(
		SELECT "nameFacility", "subtypeOf"
		FROM facility 
		WHERE "nameFacility" = $1
		UNION ALL
		SELECT child."nameFacility", child."subtypeOf"
		FROM facility as child
			JOIN cat_tree as parent ON parent."subtypeOf" = child."nameFacility")
		SELECT "nameFacility" into facility_0 FROM cat_tree WHERE "subtypeOf" IS NULL;
RETURN facility_0;
END;
$BODY$ LANGUAGE plpgsql;

SELECT "helper_find_parent_facility"('Coffee Kit');

------query
SELECT * FROM (SELECT "idHotel", "idRoom" FROM room --i found all the rooms and roomtypes at each hotel
				GROUP BY "idHotel", roomtype, "idRoom" 
				EXCEPT                                         --and i subtracked with no available rooms tonight
				SELECT "idHotel", "idRoom"  FROM roombooking, room 
				WHERE roombooking."roomID" = room."idRoom"
					and ((SELECT CURRENT_DATE ) < roombooking.checkout and (SELECT CURRENT_DATE )> roombooking.checkin)
				GROUP BY "idHotel", roomtype, "idRoom") as query1, hotelfacilities, roomfacilities 
WHERE query1."idHotel" = hotelfacilities."idHotel" and query1."idRoom" = roomfacilities."idRoom" 
	and (SELECT "helper_find_parent_facility"(hotelfacilities."nameFacility")) = 'Kids Services' 
	and (SELECT "helper_find_parent_facility"(roomfacilities."nameFacility")) = 'Kid Amenities'