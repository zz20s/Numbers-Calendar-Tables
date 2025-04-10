USE [MSD]; 
GO

/****** Object:  UserDefinedFunction [dbo].[IsHoliday]    Script Date: 4/8/2025 12:44:53 PM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


CREATE OR ALTER FUNCTION [dbo].[IsHoliday]
    (
        @date AS         DATETIME,
        @holiday_name AS VARCHAR(255)
    )
/*
@holiday_name takes the following:
NULL  -- look for ANY holiday 
'NYD' -- New Year's Day (January 1 of every year)
'MLK' -- Martin Luther King Jr. Day (third Monday of January each year)
'SBS' -- Super Bowl Sunday (Second Sunday in February)
'VAL' -- Valentine's Day (February 14 of every year)
'PRE' -- President's Day (third Monday in February)
'STP' -- Saint Patrick's Day (March 17 of each year)
'MOT' -- Mother's Day (second Sunday in May)
'MEM' -- Memorial Day (last Monday in May)
'JUN' -- Juneteenth (June 19th of every year)
'FAT' -- Father's Day (third Sunday in June)
'IND' -- American Independence Day (July 4 every year)
'LAB' -- Labor Day (first Monday in September)
'COL' -- Columbus Day (second Monday in October)
'HAL' -- Halloween (October 31 of every year)
'VET' -- Veteran's Day (November 11 of every year)
'THK' -- Thanksgiving Day (fourth Thursday in November)
'CRE' -- Christmas Eve (December 24 of every year)
'CRD' -- Christmas Day (December 25 of every year)
'NYE' -- New Year's Eve (December 31 of every year)
*/

RETURNS BIT
AS
    BEGIN
        IF @date IS NOT NULL
            BEGIN
                /*JANUARY*/
                IF (
                       @holiday_name = 'NYD'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 1
                   AND DAY(@date) = 1
                    RETURN 1; -- New Years Day
                IF (
                       @holiday_name = 'MLK'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 1
                   AND DATEPART(WEEKDAY, @date) = 2
                   AND DAY(@date) > 14
                   AND DAY(@date) <= 21
                    RETURN 1; -- Martin Luther King, Jr. Day
                /*FEBURARY*/
                IF (
                       @holiday_name = 'SBS'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 2
                   AND DATEPART(WEEKDAY, @date) = 1
                   AND DAY(@date) <= 7
                    RETURN 1; -- Super Bowl Sunday
                IF (
                       @holiday_name = 'VAL'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 2
                   AND DAY(@date) = 14
                    RETURN 1; -- Valentine's Day
                IF (
                       @holiday_name = 'PRE'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 2
                   AND DATEPART(WEEKDAY, @date) = 2
                   AND DAY(@date) > 14
                   AND DAY(@date) <= 21
                    RETURN 1; -- Presidents' Day
                /*MARCH*/
                IF (
                       @holiday_name = 'STP'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 3
                   AND DAY(@date) = 17
                    RETURN 1; -- St Patrick's Day
                /*APRIL*/
                /*MAY*/
                IF (
                       @holiday_name = 'MOT'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 5
                   AND DATEPART(WEEKDAY, @date) = 1
                   AND DAY(@date) > 7
                   AND DAY(@date) <= 14
                    RETURN 1; -- Mother's day
                IF (
                       @holiday_name = 'MEM'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 5
                   AND DATEPART(WEEKDAY, @date) = 2
                   AND DAY(@date) > 24
                   AND DAY(@date) <= 31
                    RETURN 1; --Memorial Day
                /*JUNE*/
                IF (
                       @holiday_name = 'JUN'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 6
                   AND DAY(@date) = 19
                    RETURN 1; -- Juneteenth
                IF (
                       @holiday_name = 'FAT'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 6
                   AND DATEPART(WEEKDAY, @date) = 2
                   AND DAY(@date) > 14
                   AND DAY(@date) <= 21
                    RETURN 1; --Father's Day
                /*JULY*/
                IF (
                       @holiday_name = 'IND'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 7
                   AND DAY(@date) = 4
                    RETURN 1; -- American Independence Day
                /*SEPTEMBER*/
                IF (
                       @holiday_name = 'LAB'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 9
                   AND DATEPART(WEEKDAY, @date) = 2
                   AND DAY(@date) <= 7
                    RETURN 1; --Labor Day
                /*OCTOBER*/
                IF (
                       @holiday_name = 'COL'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 10
                   AND DATEPART(WEEKDAY, @date) = 2
                   AND DAY(@date) > 7
                   AND DAY(@date) <= 14
                    RETURN 1; --Columbus Day
                IF (
                       @holiday_name = 'HAL'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 10
                   AND DAY(@date) = 31
                    RETURN 1; -- Halloween
                /*NOVEMBER*/
                IF (
                       @holiday_name = 'VET'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 11
                   AND DAY(@date) = 11
                    RETURN 1; -- Veteran's Day
                IF (
                       @holiday_name = 'THK'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 11
                   AND DATEPART(WEEKDAY, @date) = 5
                   AND DAY(@date) > 21
                   AND DAY(@date) <= 28
                    RETURN 1; --Thanksgiving
                /*DECEMBER*/
                IF (
                       @holiday_name = 'CRE'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 12
                   AND DAY(@date) = 24
                    RETURN 1; -- Christmas Eve
                IF (
                       @holiday_name = 'CRD'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 12
                   AND DAY(@date) = 25
                    RETURN 1; -- Christmas Day
                IF (
                       @holiday_name = 'NYE'
                       OR @holiday_name IS NULL
                   )
                   AND MONTH(@date) = 12
                   AND DAY(@date) = 31
                    RETURN 1; -- NYE    

            END;
        RETURN 0;
    END;
GO


