/* 
The number of taxi trips completed by each cab company was calculated for November 15 and 16, 2017. 
The results include the company names and the corresponding trip counts (labeled as trips_amount). 
The data was grouped by company and sorted in descending order based on the number of trips to 
highlight the most active taxi services during that period.
*/
SELECT 
    cabs.company_name,
    count (trips.trip_id) AS trips_amount
FROM
    cabs
INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE CAST (trips.start_ts AS date) BETWEEN '2017-11-15' AND '2017-11-16' 
GROUP BY cabs.company_name
ORDER BY trips_amount DESC;

/* 
The total number of taxi trips was calculated for each company whose name includes the words “Yellow” 
or “Blue” during the period from November 1 to November 7, 2017. The resulting variable, trips_amount,
 represents the total trips made by each of these companies. The data was grouped by company name to 
 compare the activity levels of the selected taxi services.
*/
SELECT 
    cabs.company_name,
    COUNT (trips.trip_id) AS trips_amount
FROM cabs
INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE
    CAST (trips.start_ts AS date) BETWEEN '2017-11-1' AND '2017-11-7'
    AND (cabs.company_name LIKE '%Yellow%'
    OR cabs.company_name LIKE '%Blue%')
GROUP BY cabs.company_name

/*
Between November 1 and 7, 2017, the analysis focused on identifying the most popular taxi companies. 
The trip data was grouped to highlight Flash Cab and Taxi Affiliation Services, while all remaining 
companies were consolidated under the label “Other.” The total number of trips for each group was 
calculated and stored in the variable trips_amount. Finally, the results were sorted in descending order
 of trip volume to emphasize the companies with the highest activity during that week.
*/
SELECT 
    CASE 
        WHEN cabs.company_name IN ('Flash Cab', 'Taxi Affiliation Services') THEN cabs.company_name 
        ELSE 'Other'
    END AS company,
    COUNT(trips.trip_id) AS trips_amount
FROM cabs
INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07'
GROUP BY 
    CASE 
        WHEN cabs.company_name IN ('Flash Cab', 'Taxi Affiliation Services') THEN cabs.company_name 
        ELSE 'Other'
    END
ORDER BY 
    trips_amount DESC;

/*
The neighborhood identifiers were retrieved for the areas O'Hare and Loop from the neighborhoods table.
The query selected both the neighborhood names and their corresponding IDs to isolate these specific 
locations for further analysis.
*/
SELECT name,neighborhood_id
FROM neighborhoods
WHERE name LIKE '%Hare'
   OR name LIKE 'Loop'

/*
Weather condition records were retrieved for each hour from the weather_records table. Using a CASE statement
, all hourly entries were classified into two categories: “Bad” when the description field contained the words
 “rain” or “storm,” and “Good” for all other cases. The resulting table included two columns — the timestamp 
 (ts) and the corresponding weather_conditions — providing a simplified overview of hourly weather patterns.
*/

/*SELECT * FROM weather_records*/
SELECT
    ts,
    CASE
        WHEN (description LIKE '%rain%' OR description LIKE '%storm%') THEN 'Bad'
        ELSE 'Good'
    END AS weather_conditions
FROM
    weather_records

/*
Trip data was extracted from the trips table to identify all rides that began in the Loop (pickup_location_id = 50)
 on Saturday and ended in O’Hare (dropoff_location_id = 63). Weather conditions for each trip were obtained using 
the same classification method as in the previous task, labeling conditions as “Bad” when the description included
“rain” or “storm,” and “Good” otherwise. The resulting table included the trip start time (start_ts), corresponding
weather_conditions, and duration_seconds. Only trips with available weather data were considered, and the results
were ordered by trip_id.
*/

SELECT 
    trips.start_ts,
    subq.weather_conditions,
    trips.duration_seconds
FROM 
    trips
INNER JOIN (
    SELECT
    ts,
    CASE
        WHEN (description LIKE '%rain%' OR description LIKE '%storm%') THEN 'Bad'
        ELSE 'Good'
    END AS weather_conditions
FROM
    weather_records) AS subq ON trips.start_ts = subq.ts
WHERE 
    pickup_location_id = 50 
    AND dropoff_location_id = 63
    AND EXTRACT (DOW FROM trips.start_ts) = 6
ORDER BY 
    trips.trip_id