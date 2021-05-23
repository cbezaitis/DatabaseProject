CREATE OR REPLACE FUNCTION "3_6_subtypeof"(subtypeof character varying(45)) 

RETURNS table(namefacility character varying(45))
							 AS
$BODY$
DECLARE facility_0 character varying(45);
BEGIN
SELECT "nameFacility" into facility_0 FROM facility WHERE "nameFacility" = $1 and "subtypeOf" IS NULL;
IF facility_0 IS NULL THEN 
    RETURN NEXT;  
ELSE 
    RETURN QUERY (WITH recursive cat_tree as(
		SELECT "nameFacility", "subtypeOf" 
		FROM facility 
		WHERE "subtypeOf" = $1
		UNION ALL
		SELECT child."nameFacility", child."subtypeOf"
		FROM facility as child
			join cat_tree as parent on parent."nameFacility" = child."subtypeOf")
		SELECT "nameFacility" from cat_tree );
END IF;
END;
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "3_6_subtypeof"('Beverages & Drinks');
SELECT * FROM "3_6_subtypeof"('Brandy');

-----query 
WITH recursive cat_tree as(
	SELECT "nameFacility", "subtypeOf" 
	FROM facility 
	WHERE "subtypeOf" = $1
	UNION ALL
	SELECT child."nameFacility", child."subtypeOf"
	FROM facility as child
		join cat_tree as parent on parent."nameFacility" = child."subtypeOf"
)
SELECT "nameFacility" from cat_tree;