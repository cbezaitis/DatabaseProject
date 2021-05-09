CREATE FUNCTION "3_5_search_for_activities"(hotel integer) 

RETURNS table(start_time time without time zone, end_time time without time zone, "Day" weekday, activity activity_type)
							 AS
$BODY$
BEGIN
RETURN QUERY
	SELECT starttime, endtime, "Weekday", activitytype FROM activity as activity  
    WHERE NOT EXISTS (
         SELECT * FROM participates as participates
               WHERE activity.starttime = participates.starttime and activity.endtime = participates.endtime 
	                 and activity."Weekday" = participates.weekday and activity."idHotel" = participates."idHotel"
	                 and participates."idHotel" = $1 and participates.role = 'participant');
END
$BODY$ LANGUAGE plpgsql;


-----query 

SELECT starttime, endtime, "Weekday", activitytype FROM activity as activity  
    WHERE NOT EXISTS (
         SELECT * FROM participates as participates
               WHERE activity.starttime = participates.starttime and activity.endtime = participates.endtime 
	                 and activity."Weekday" = participates.weekday and activity."idHotel" = participates."idHotel"
	                 and participates."idHotel" = 27 and participates.role = 'participant')