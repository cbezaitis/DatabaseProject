SELECT *
FROM activity as activity
WHERE NOT EXISTS(
	SELECT * 
	FROM participates
	where participates.starttime = activity.starttime and 
	participates.endtime = activity.endtime 
	participates.weekday = activity.weekday 
);


--	participates.weekday = activity.weekday  to Activity.weekday giati to xehasame mallon 
-- Eipa na tin allaxoume mazi tin vasi giati einai perierga pragmata auta 

