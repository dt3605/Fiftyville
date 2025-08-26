-- Fiftyville Mystery Investigation
-- CS50 Project
-- This log file keeps track of all queries used to solve the theft of the CS50 Duck on July 28, 2021 at Humphrey Street.

-- STEP 1: Confirm the crime scene details
-- We want to verify the date, location, and get the crime report id for reference
SELECT id,
       description
FROM crime_scene_reports
WHERE year = 2021
  AND month = 7
  AND day = 28
  AND street LIKE '%Humphrey%';

-- STEP 2: Check interviews for clues
-- Look for mentions of the bakery, which is a key point in the timeline
SELECT name,
       transcript
FROM interviews
WHERE year = 2021
  AND month = 7
  AND day = 28
  AND transcript LIKE '%bakery%';

-- STEP 3: Identify suspects using ATM transactions, phone calls, car logs, and flights
-- Use CTEs (Common Table Expressions) for clarity

-- 3a: Suspects who withdrew money from Leggett Street ATM on July 28
WITH bank_details AS (
    SELECT DISTINCT pe.name
    FROM people AS pe
    JOIN bank_accounts AS ba ON pe.id = ba.person_id
    JOIN atm_transactions AS at ON ba.account_number = at.account_number
    WHERE at.account_number IN (
        SELECT account_number
        FROM atm_transactions
        WHERE year = 2021
          AND month = 7
          AND day = 28
          AND atm_location LIKE '%Leggett Street%'
          AND transaction_type = 'withdraw'
    )
),

-- 3b: People making short phone calls (<60min) on the day of the crime
phone_details AS (
    SELECT name
    FROM people
    WHERE phone_number IN (
        SELECT CALLER
        FROM phone_calls
        WHERE year = 2021
          AND month = 7
          AND day = 28
          AND duration < 60
    )
),

-- 3c: People seen leaving the bakery between 10:15 and 10:25
car_details AS (
    SELECT name
    FROM people
    WHERE license_plate IN (
        SELECT license_plate
        FROM bakery_security_logs
        WHERE year = 2021
          AND month = 7
          AND day = 28
          AND activity = 'exit'
          AND minute > 15
          AND minute <= 25
    )
),

-- 3d: People on the earliest flight from Fiftyville on July 29
flight_details AS (
    SELECT pe.name,
           fl.origin_airport_id,
           fl.destination_airport_id
    FROM people AS pe
    JOIN passengers AS pa ON pe.passport_number = pa.passport_number
    JOIN flights AS fl ON pa.flight_id = fl.id
    WHERE fl.id IN (
        SELECT id
        FROM flights
        WHERE year = 2021
          AND month = 7
          AND day = 29
        ORDER BY hour
        LIMIT 1
    )
      AND origin_airport_id IN (
        SELECT id
        FROM airports
        WHERE city = 'Fiftyville'
    )
),

-- STEP 4: Get details for origin and destination airports
origin_airport AS (
    SELECT *
    FROM airports
    WHERE id IN (
        SELECT origin_airport_id
        FROM flights
        WHERE year = 2021
          AND month = 7
          AND day = 29
        ORDER BY hour
        LIMIT 1
    )
),
destination_airport AS (
    SELECT *
    FROM airports
    WHERE id IN (
        SELECT destination_airport_id
        FROM flights
        WHERE year = 2021
          AND month = 7
          AND day = 29
        ORDER BY hour
        LIMIT 1
    )
),

-- STEP 5: Narrow down suspects by combining all criteria
suspects AS (
    SELECT pe.name,
           pe.phone_number,
           fd.*
    FROM people AS pe
    JOIN bank_details AS bd ON pe.name = bd.name
    JOIN phone_details AS pd ON bd.name = pd.name
    JOIN car_details AS cd ON pd.name = cd.name
    JOIN flight_details AS fd ON cd.name = fd.name
    ORDER BY pe.name
)

-- STEP 6: Final report - match phone calls with flights to identify thief, accomplice, and city
SELECT sp.name AS thief_name,
       pe.name AS accomplice_name,
       oa.full_name AS origin_airport,
       da.full_name AS destination_airport,
       da.city AS city,
       pc.CALLER AS thief_phone,
       pc.receiver AS accomplice_phone
FROM phone_calls AS pc
JOIN suspects AS sp ON sp.phone_number = pc.CALLER
JOIN people AS pe ON pc.receiver = pe.phone_number
JOIN origin_airport AS oa ON 1=1
JOIN destination_airport AS da ON 1=1
WHERE pc.year = 2021
  AND pc.month = 7
  AND pc.day = 28
  AND pc.duration < 60;

-- The output of this query should give the thief, accomplice, and city they escaped to.
