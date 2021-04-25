SELECT DISTINCT(hotelbooking_0.idhotelbooking), person_0.fname, person_0.lname,
hotelbooking_0.reservationdate
FROM room as room_0 , roombooking as roombooking_0 , 
hotelbooking as hotelbooking_0, client as client_0, person as person_0
WHERE room_0."idHotel" = 74 and room_0."idRoom" = roombooking_0."roomID"
and roombooking_0."hotelbookingID" = hotelbooking_0."idhotelbooking" and
client_0."idClient" = hotelbooking_0."bookedbyclientID" and 
person_0."idPerson" = client_0."idClient" ;


-- To manages den yparxei mallon prepei na to xanavaloume

-- Prepei na valeis mia nea kolona analoga me to poios 
-- ekane tin kratisi pelatis i ipallilos
-- Isos to case mazi me kapoio EXISTS voithisei
-- Gia paradeigma ean yparxei sto manages tin ekane ipallilos? 
-- vevaia to manages den einai oti tin ekane ipallilos 
-- Malakia erotima genika alla ok 
SELECT 
    CASE 
        WHEN EXISTS(
             SELECT * 
             FROM room as room_0 , roombooking as roombooking_0 , 
				hotelbooking as hotelbooking_0, Manages as manages
             WHERE room_0."idHotel" = 74 and room_0."idRoom" = roombooking_0."roomID"
             and roombooking_0."hotelbookingID" = hotelbooking_0."idhotelbooking" 
			 and hotelbooking_0."idhotelbooking" = manages."hotelbooking_idhotelbooking"
			)
        THEN "employee" -- 'NOT ALL'

        ELSE "pelatis" -- 'ALL'
    END