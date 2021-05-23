---------------------------------------------------clients
CREATE FUNCTION "2_1_insert_person"(documentcl character varying(45), f_name character varying(45),
							 l_name character varying(45), sexy character(1), dateof_birth date, 
							 address_1 character varying(45), city_1 character varying(45), country_1 character varying(45)) 
RETURNS table("id" integer, documentclie character varying(45)) AS
$BODY$
DECLARE idpers integer;
BEGIN
INSERT INTO person(fname, lname, sex, dateofbirth, address, city, country) 
      VALUES ($2, $3, $4, $5, $6, $7, $8)
	  RETURNING "idPerson" INTO idpers;
INSERT INTO client("idClient", documentclient)
      VALUES (idpers, $1);
RETURN QUERY
   SELECT *
   FROM client 
   WHERE "idClient" = idpers;
END
$BODY$ LANGUAGE plpgsql;

CREATE FUNCTION "2_1_update_person"(documentcl character varying(45), f_name character varying(45),
							 l_name character varying(45), sexy character(1), dateof_birth date, 
							 address_1 character varying(45), city_1 character varying(45), country_1 character varying(45)) 
RETURNS table("id" integer, first_name character varying(45),last_name character varying(45), sexi character(1), date_of_birth date, 
							 address_2 character varying(45), city_2 character varying(45), country_2 character varying(45)) AS
$BODY$
DECLARE idpers integer;
BEGIN
SELECT "idClient" INTO idpers
FROM client 
WHERE documentclient=$1;
UPDATE person SET fname=$2, lname=$3, sex=$4, dateofbirth=$5, address=$6, city=$7, country=$8
      WHERE "idPerson" = idpers;
RETURN QUERY
   SELECT *
   FROM person 
   WHERE "idPerson" = idpers;
END
$BODY$ LANGUAGE plpgsql;

CREATE FUNCTION "2_1_delete_person"(documentcl character varying(45), f_name character varying(45),
							 l_name character varying(45), sexy character(1), dateof_birth date, 
							 address_1 character varying(45), city_1 character varying(45), country_1 character varying(45)) 
RETURNS table("id" integer, first_name character varying(45),last_name character varying(45), sexi character(1), date_of_birth date, 
							 address_2 character varying(45), city_2 character varying(45), country_2 character varying(45)) AS
$BODY$
DECLARE idpers integer;
BEGIN
DELETE FROM client WHERE documentclient = $1 RETURNING "idClient" INTO idpers;
DELETE FROM person WHERE "idPerson" = idpers;
RETURN QUERY
   SELECT *
   FROM person 
   WHERE "idPerson" = idpers;
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "2_1_insert_person"('145768867656879', 'jim12', 'papanikolopoulos', 'M', '1996-07-13', 'lykourgou 2', 'gerakas', 'athens');
SELECT * FROM "2_1_update_person"('145768867656879', 'jim1233', 'papanikolopoulos', 'M', '1996-07-13', 'lykourgou 2', 'gerakas', 'athens');
SELECT * FROM "2_1_delete_person"('145768867656879', 'jim1233', 'papanikolopoulos', 'M', '1996-07-13', 'lykourgou 2', 'gerakas', 'athens'); 
--------------------------------------------------cards
CREATE FUNCTION "2_1_insert_card"(documentcl character varying(45), card_type_1 character varying(45),
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

CREATE FUNCTION "2_1_update_card"(documentcl character varying(45), card_type_1 character varying(45),
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
UPDATE creditcard SET cardtype=$2, "number"=$3, expiration=$4, holder=$5, "clientID"=idpers
                  WHERE "clientID"=idpers AND "number"=$3 AND cardtype=$2;
RETURN QUERY
   SELECT *
   FROM creditcard 
   WHERE "clientID" = idpers;
END
$BODY$ LANGUAGE plpgsql;

CREATE FUNCTION "2_1_delete_card"(documentcl character varying(45), card_type_1 character varying(45),
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
DELETE FROM creditcard WHERE "clientID"=idpers AND "number"=$3 AND cardtype=$2;
RETURN QUERY
   SELECT *
   FROM creditcard 
   WHERE "clientID" = idpers;
END
$BODY$ LANGUAGE plpgsql;

SELECT * FROM "2_1_insert_card"('145768867656879', 'VISA', '2053 4567 8739 9002', '2021-07-13', 'JIM PAPANIKOLOPOULOS' );
SELECT * FROM "2_1_update_card"('145768867656879', 'VISA', '2053 4567 8739 9002', '2022-07-13', 'JIM PAPANIKOLOPOULOS' );
SELECT * FROM "2_1_delete_card"('145768867656879', 'VISA', '2053 4567 8739 9002', '2022-07-13', 'JIM PAPANIKOLOPOULOS' );