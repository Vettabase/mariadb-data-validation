CREATE OR REPLACE DATABASE vetta_validation
    COMMENT 'Vettabase data validation library
https://github.com/Vettabase/mariadb-data-validation'
;
USE vetta_validation;


DELIMITER ||


-- Generic Functions
-- =================

CREATE FUNCTION number_is_one_of(i_value INT, i_array JSON)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT "Return whether the first INT argument is one of the values in the JSON array passed as the second argument.

Example:
SELECT number_is_one_of(1, JSON_ARRAY(1, 2, 3));
"
BEGIN
    RETURN JSON_CONTAINS(i_array, i_value);
END ||

CREATE FUNCTION string_is_one_of(i_value TEXT, i_array JSON)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT "Return whether the first string argument is one of the values in the JSON array passed as the second argument.

Example:
SELECT string_is_one_of('one', JSON_ARRAY('one', 'two', 'three'));
"
BEGIN
    RETURN JSON_CONTAINS(i_array, JSON_QUOTE(i_value));
END ||

CREATE FUNCTION string_length_between(i_value TEXT, i_min INT, i_max INT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT "Return whether the first string argument length is between the min and max arguments.

Example:
SELECT string_length_between('qwertyuiop', 3, 50);
"
BEGIN
    DECLARE v_length INTEGER SIGNED
        DEFAULT CHAR_LENGTH(i_value);
    RETURN v_length >= i_min AND v_length <= i_max;
END ||


-- Generic INT Functions
-- =====================

CREATE FUNCTION is_multiple_of(i_dividend INT, i_divisor INT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the first argument can be divided by the second, obtaining an integer result.'
BEGIN
    IF i_divisor = 0 THEN
        RETURN FALSE;
    END IF;
    RETURN NOT (i_dividend MOD i_divisor);
END ||

CREATE FUNCTION is_even(i_value INT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the integer argument is even (can be divided by 2).'
BEGIN
    RETURN NOT (i_value MOD 2);
END ||

CREATE FUNCTION is_odd(i_value INT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the integer argument is odd (cannot be divided by 2).'
BEGIN
    RETURN i_value MOD 2;
END ||


-- Generic String Functions
-- ========================

CREATE FUNCTION is_digits(i_value TEXT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the string argument consists of digits only.'
BEGIN
    RETURN i_value REGEXP '^[[:digit:]]+$';
END ||

CREATE FUNCTION is_alphabetic(i_value TEXT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the string argument consists of letters only.'
BEGIN
    RETURN i_value REGEXP '^[[:alpha:]]+$';
END ||

CREATE FUNCTION is_alphanumeric(i_value TEXT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the string argument consists of alphanumeric characters only.'
BEGIN
    RETURN i_value REGEXP '^[[:alnum:]]+$';
END ||

CREATE FUNCTION is_lower(i_value TEXT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the string argument consists of lowercase letters only.'
BEGIN
    RETURN i_value REGEXP '^[[:lower:]]+$';
END ||

CREATE FUNCTION is_upper(i_value TEXT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the string argument consists of uppercase letters only.'
BEGIN
    RETURN i_value REGEXP '^[[:upper:]]+$';
END ||


-- Specific Functions
-- ==================

CREATE FUNCTION is_email(i_email TEXT)
    RETURNS BOOL
    DETERMINISTIC
    CONTAINS SQL
    COMMENT 'Return whether the argument is a valid email address.'
BEGIN
    RETURN i_email LIKE '_%@_%.__%';
END ||

DELIMITER ;
