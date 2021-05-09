CREATE FUNCTION "4_1_count_activities_by_client"(hotel integer) 
RETURNS table("idperson" integer, number_of_activities bigint)
							 AS
$BODY$
BEGIN
RETURN QUERY
	SELECT "idPerson", count(*) FROM participates 
      WHERE "idHotel" = $1 and "role" = 'participant'
	  GROUP BY "idPerson";
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "4_1_count_activities_by_client"(27);
-----query 
SELECT "idPerson", count(*) FROM participates 
      WHERE "idHotel" = 27 and "role" = 'participant'
	  GROUP BY "idPerson";