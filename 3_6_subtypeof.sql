CREATE FUNCTION "3_6_subtypeof"(subtypeof character varying(45)) 

RETURNS table(namefacility character varying(45))
							 AS
$BODY$
DECLARE facility_0 character varying(45);
BEGIN
SELECT "nameFacility" into facility_0 FROM facility WHERE "nameFacility" = $1 and "subtypeOf" IS NULL;
IF facility_0 IS NULL THEN RETURN QUERY SELECT * FROM facility WHERE "subtypeOf" = $1;
ELSE 
    RAISE NOTICE '% name facility is not a first level facility', $1;
    RETURN NULL;  
END IF;
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "3_6_subtypeof"('Beverages & Drinks');