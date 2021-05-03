SELECT *
FROM activity as activity , hotel as hotel 
WHERE NOT EXISTS(
	SELECT * 
	FROM participates
	where participates.starttime = activity.starttime and 
	participates.endtime = activity.endtime and
	participates.weekday = activity.weekday 
) and  activity."idHotel" = hotel."idHotel" and hotel."idHotel" = 5;


--	participates.weekday = activity.weekday  to Activity.weekday giati to xehasame mallon 
-- Eipa na tin allaxoume mazi tin vasi giati einai perierga pragmata auta 

