-- Keep a log of any SQL queries you execute as you solve the mystery.

-- theft took place on July 28, 2024 and that it took place on Humphrey Street

SELECT * FROM crime_scene_reports WHERE year = 2024 AND month = 7 AND day = 28 AND street = 'Humphrey Street';
-- robbery took place at 10:15am and there were 3 witnesses

SELECT * FROM interviews WHERE year = 2024 AND month = 7 AND day = 28;
-- Witness 1: Sometime within ten minutes of the theft,
-- I saw the thief get into a car in the bakery parking lot and drive away.
-- If you have security footage from the bakery parking lot,
-- you might want to look for cars that left the parking lot in that time frame

-- Witness 2: I don't know the thief's name, but it was someone I recognized.
-- Earlier this morning, before I arrived at Emma's bakery,
-- I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.

-- Witness 3: As the thief was leaving the bakery, they called someone who talked to them for less than a minute.
-- In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.

SELECT * FROM bakery_security_logs WHERE year = 2024 AND month = 7 AND day = 28 AND hour = 10 AND activity = 'exit';
-- +-----+------+-------+-----+------+--------+----------+---------------+
-- | id  | year | month | day | hour | minute | activity | license_plate |
-- +-----+------+-------+-----+------+--------+----------+---------------+
-- | 260 | 2024 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
-- | 261 | 2024 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
-- | 262 | 2024 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
-- | 263 | 2024 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
-- | 264 | 2024 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
-- | 265 | 2024 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
-- | 266 | 2024 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
-- | 267 | 2024 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
-- | 268 | 2024 | 7     | 28  | 10   | 35     | exit     | 1106N58       |
-- +-----+------+-------+-----+------+--------+----------+---------------+

SELECT * FROM atm_transactions WHERE year = 2024 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street' ORDER BY id ASC;
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- | id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- | 246 | 28500762       | 2024 | 7     | 28  | Leggett Street | withdraw         | 48     |
-- | 264 | 28296815       | 2024 | 7     | 28  | Leggett Street | withdraw         | 20     |
-- | 266 | 76054385       | 2024 | 7     | 28  | Leggett Street | withdraw         | 60     |
-- | 267 | 49610011       | 2024 | 7     | 28  | Leggett Street | withdraw         | 50     |
-- | 269 | 16153065       | 2024 | 7     | 28  | Leggett Street | withdraw         | 80     |
-- | 275 | 86363979       | 2024 | 7     | 28  | Leggett Street | deposit          | 10     |
-- | 288 | 25506511       | 2024 | 7     | 28  | Leggett Street | withdraw         | 20     |
-- | 313 | 81061156       | 2024 | 7     | 28  | Leggett Street | withdraw         | 30     |
-- | 336 | 26013199       | 2024 | 7     | 28  | Leggett Street | withdraw         | 35     |
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+

SELECT * FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration <= 60;
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | id  |     caller     |    receiver    | year | month | day | duration |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | 221 | (130) 555-0289 | (996) 555-8899 | 2024 | 7     | 28  | 51       |
-- | 224 | (499) 555-9472 | (892) 555-8872 | 2024 | 7     | 28  | 36       |
-- | 233 | (367) 555-5533 | (375) 555-8161 | 2024 | 7     | 28  | 45       |
-- | 234 | (609) 555-5876 | (389) 555-5198 | 2024 | 7     | 28  | 60       |
-- | 251 | (499) 555-9472 | (717) 555-1342 | 2024 | 7     | 28  | 50       |
-- | 254 | (286) 555-6063 | (676) 555-6554 | 2024 | 7     | 28  | 43       |
-- | 255 | (770) 555-1861 | (725) 555-3243 | 2024 | 7     | 28  | 49       |
-- | 261 | (031) 555-6622 | (910) 555-3251 | 2024 | 7     | 28  | 38       |
-- | 279 | (826) 555-1652 | (066) 555-9701 | 2024 | 7     | 28  | 55       |
-- | 281 | (338) 555-6650 | (704) 555-2131 | 2024 | 7     | 28  | 54       |
-- +-----+----------------+----------------+------+-------+-----+----------+

SELECT * FROM airports WHERE city = 'Fiftyville';
-- airport id = 8

SELECT * FROM flights WHERE year = 2024 AND month = 7 AND day = 29 AND origin_airport_id = 8 ORDER BY hour ASC;
-- +----+-------------------+------------------------+------+-------+-----+------+--------+
-- | id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
-- +----+-------------------+------------------------+------+-------+-----+------+--------+
-- | 36 | 8                 | 4                      | 2024 | 7     | 29  | 8    | 20     |
-- | 43 | 8                 | 1                      | 2024 | 7     | 29  | 9    | 30     |
-- | 23 | 8                 | 11                     | 2024 | 7     | 29  | 12   | 15     |
-- | 53 | 8                 | 9                      | 2024 | 7     | 29  | 15   | 20     |
-- | 18 | 8                 | 6                      | 2024 | 7     | 29  | 16   | 0      |
-- +----+-------------------+------------------------+------+-------+-----+------+--------+

SELECT *
FROM people
WHERE license_plate
IN (SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND hour = 10
    AND activity = 'exit');
-- +--------+---------+----------------+-----------------+---------------+
-- |   id   |  name   |  phone_number  | passport_number | license_plate |
-- +--------+---------+----------------+-----------------+---------------+
-- | 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       |
-- | 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       |
-- | 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
-- | 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       |
-- | 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
-- | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       |
-- | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
-- +--------+---------+----------------+-----------------+---------------+

SELECT *
FROM people
WHERE id
IN (SELECT person_id
    FROM bank_accounts
    WHERE account_number
    IN (SELECT account_number
        FROM atm_transactions
        WHERE year = 2024
        AND month = 7
        AND day = 28
        AND transaction_type = 'withdraw'
        AND atm_location = 'Leggett Street'));
-- +--------+---------+----------------+-----------------+---------------+
-- |   id   |  name   |  phone_number  | passport_number | license_plate |
-- +--------+---------+----------------+-----------------+---------------+
-- | 395717 | Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       |
-- | 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
-- | 438727 | Benista | (338) 555-6650 | 9586786673      | 8X428L0       |
-- | 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 458378 | Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       |
-- | 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
-- | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
-- +--------+---------+----------------+-----------------+---------------+

SELECT *
FROM people
WHERE phone_number
IN (SELECT caller
    FROM phone_calls
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND duration <= 60);
-- +--------+---------+----------------+-----------------+---------------+
-- | 395717 | Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       |
-- | 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       |
-- | 438727 | Benista | (338) 555-6650 | 9586786673      | 8X428L0       |
-- | 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       |
-- | 561160 | Kathryn | (609) 555-5876 | 6121106406      | 4ZY7I8T       |
-- | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
-- | 907148 | Carina  | (031) 555-6622 | 9628244268      | Q12B3Z3       |
-- +--------+---------+----------------+-----------------+---------------+

SELECT *
FROM people
WHERE license_plate
IN (SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND hour = 10
    AND activity = 'exit')
INTERSECT
SELECT *
FROM people
WHERE passport_number
IN (SELECT passport_number
    FROM passengers
    WHERE flight_id
    IN (SELECT id
        FROM flights
        WHERE year = 2024
        AND month = 7
        AND day = 29
        AND origin_airport_id = 8));
-- +--------+--------+----------------+-----------------+---------------+
-- |   id   |  name  |  phone_number  | passport_number | license_plate |
-- +--------+--------+----------------+-----------------+---------------+
-- | 398010 | Sofia  | (130) 555-0289 | 1695452385      | G412CB7       |
-- | 449774 | Taylor | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 467400 | Luca   | (389) 555-5198 | 8496433585      | 4328GD8       |
-- | 514354 | Diana  | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 560886 | Kelsey | (499) 555-9472 | 8294398571      | 0NTHK55       |
-- | 686048 | Bruce  | (367) 555-5533 | 5773159633      | 94KL13X       |
-- +--------+--------+----------------+-----------------+---------------+

SELECT *
FROM people
WHERE id
IN (SELECT person_id
    FROM bank_accounts
    WHERE account_number
    IN (SELECT account_number
        FROM atm_transactions
        WHERE year = 2024
        AND month = 7
        AND day = 28
        AND transaction_type = 'withdraw'
        AND atm_location = 'Leggett Street'))
INTERSECT
SELECT *
FROM people
WHERE passport_number
IN (SELECT passport_number
    FROM passengers
    WHERE flight_id
    IN (SELECT id
        FROM flights
        WHERE year = 2024
        AND month = 7
        AND day = 29
        AND origin_airport_id = 8));
-- +--------+--------+----------------+-----------------+---------------+
-- |   id   |  name  |  phone_number  | passport_number | license_plate |
-- +--------+--------+----------------+-----------------+---------------+
-- | 395717 | Kenny  | (826) 555-1652 | 9878712108      | 30G67EN       |
-- | 449774 | Taylor | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 458378 | Brooke | (122) 555-4581 | 4408372428      | QX4YZN3       |
-- | 467400 | Luca   | (389) 555-5198 | 8496433585      | 4328GD8       |
-- | 514354 | Diana  | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 686048 | Bruce  | (367) 555-5533 | 5773159633      | 94KL13X       |
-- +--------+--------+----------------+-----------------+---------------+

SELECT *
FROM people
WHERE phone_number
IN (SELECT caller
    FROM phone_calls
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND duration <= 60)
INTERSECT
SELECT *
FROM people
WHERE passport_number
IN (SELECT passport_number
    FROM passengers
    WHERE flight_id
    IN (SELECT id
        FROM flights
        WHERE year = 2024
        AND month = 7
        AND day = 29
        AND origin_airport_id = 8));
-- +--------+--------+----------------+-----------------+---------------+
-- |   id   |  name  |  phone_number  | passport_number | license_plate |
-- +--------+--------+----------------+-----------------+---------------+
-- | 395717 | Kenny  | (826) 555-1652 | 9878712108      | 30G67EN       |
-- | 398010 | Sofia  | (130) 555-0289 | 1695452385      | G412CB7       |
-- | 449774 | Taylor | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 514354 | Diana  | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 560886 | Kelsey | (499) 555-9472 | 8294398571      | 0NTHK55       |
-- | 686048 | Bruce  | (367) 555-5533 | 5773159633      | 94KL13X       |
-- +--------+--------+----------------+-----------------+---------------+

-- Both Bruce and Diana are present in all the above conditions
-- First flight out of Fiftyville was flight 36 lets check who's on it

SELECT *
FROM people
WHERE passport_number
IN (SELECT passport_number
    FROM passengers
    WHERE flight_id = 36);
-- +--------+--------+----------------+-----------------+---------------+
-- |   id   |  name  |  phone_number  | passport_number | license_plate |
-- +--------+--------+----------------+-----------------+---------------+
-- | 395717 | Kenny  | (826) 555-1652 | 9878712108      | 30G67EN       |
-- | 398010 | Sofia  | (130) 555-0289 | 1695452385      | G412CB7       |
-- | 449774 | Taylor | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 467400 | Luca   | (389) 555-5198 | 8496433585      | 4328GD8       |
-- | 560886 | Kelsey | (499) 555-9472 | 8294398571      | 0NTHK55       |
-- | 651714 | Edward | (328) 555-1152 | 1540955065      | 130LD9Z       |
-- | 686048 | Bruce  | (367) 555-5533 | 5773159633      | 94KL13X       |
-- | 953679 | Doris  | (066) 555-9701 | 7214083635      | M51FA04       |
-- +--------+--------+----------------+-----------------+---------------+

-- Diana is absent from this flight hence "Bruce" is the thief

SELECT *
FROM airports
where id
IN (SELECT destination_airport_id
    FROM flights
    WHERE id = 36);
-- +----+--------------+-------------------+---------------+
-- | id | abbreviation |     full_name     |     city      |
-- +----+--------------+-------------------+---------------+
-- | 4  | LGA          | LaGuardia Airport | New York City |
-- +----+--------------+-------------------+---------------+

-- Bruce escaped to "New York City"

SELECT *
FROM people
WHERE phone_number
IN (SELECT receiver
    FROM phone_calls
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND duration <= 60
    AND caller = '(367) 555-5533');
-- +--------+-------+----------------+-----------------+---------------+
-- |   id   | name  |  phone_number  | passport_number | license_plate |
-- +--------+-------+----------------+-----------------+---------------+
-- | 864400 | Robin | (375) 555-8161 | NULL            | 4V16VO0       |
-- +--------+-------+----------------+-----------------+---------------+

-- His Accomplice is "Robin"
