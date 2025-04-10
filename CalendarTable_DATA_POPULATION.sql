USE [MSD];

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_NAME = 'Calendar' 
      AND TABLE_SCHEMA = 'dbo'  -- adjust if needed
)
BEGIN
    THROW 50001, 'Table [dbo].[Calendar] does not exist.', 1;
END

/**DELETES EVERYTHING IN TABLE -- optional if table is already empty*/
DELETE FROM
	   [dbo].[Calendar]
WHERE
	1 = 1;

/* BASE DATA INSERT (row # and calendar_date only)*/
INSERT INTO [dbo].[Calendar]
	 ([calendar_number],
	[calendar_date],
	[calendar_date_yyyymmdd],
	[calendar_year],
	[month_of_year],
	[day_of_month],
	[day_name],
	[day_number],
	[is_weekend],
	[day_of_year],
	[week_of_year],
	[month_name],
	[quarter_of_year],
	[yyyymm],
	[is_holiday],
	[is_leap_day])
			SELECT
				[Number],
				DATEADD(DAY, [Number], '1972-01-01'),
				'99999999',
				'1972',
				1,
				1,
				'foo',
				1,
				1,
				1,
				1,
				'bar',
				1,
				1,
				0,
				0
			FROM
				[dbo].[Numbers];

UPDATE
	[dbo].[Calendar]
SET
	[calendar_date_yyyymmdd] = CONVERT(CHAR(8), [calendar_date], 112)
WHERE
	1 = 1;

UPDATE
	[dbo].[Calendar]
SET
	[calendar_year] = YEAR([calendar_date])
WHERE
	1 = 1;

UPDATE
	[dbo].[Calendar]
SET
	[month_of_year] = MONTH([calendar_date])
WHERE
	1 = 1;


UPDATE
	[dbo].[Calendar]
SET
	[day_of_month] = DAY([calendar_date])
WHERE
	1 = 1;


UPDATE
	[dbo].[Calendar]
SET
	[day_name] = DATENAME(WEEKDAY, [calendar_date])
WHERE
	1 = 1;


UPDATE
	[Calendar]
SET
	[day_number] = (DATEPART(WEEKDAY, [calendar_date]) + 5) % 7
WHERE
	1 = 1;


UPDATE
	[Calendar]
SET
	[is_weekend] = CASE
					   WHEN [day_number] IN ( 5, 6 )
							THEN 1
					   ELSE 0
				   END
WHERE
	1 = 1;


UPDATE
	[Calendar]
SET
	[day_of_year] = DATEPART(DAYOFYEAR, [calendar_date])
WHERE
	1 = 1;


UPDATE
	[Calendar]
SET
	[week_of_year] = DATEPART(ISO_WEEK, [calendar_date])
WHERE
	1 = 1;


UPDATE
	[Calendar]
SET
	[month_name] = DATENAME(MONTH, [calendar_date])
WHERE
	1 = 1;


UPDATE
	[Calendar]
SET
	[quarter_of_year] = DATEPART(QUARTER, [calendar_date])
WHERE
	1 = 1;



UPDATE
	[Calendar]
SET
	[yyyymm] = CONCAT(
				   YEAR([calendar_date]),
				   RIGHT('00' + CAST(MONTH([calendar_date]) AS VARCHAR(2)), 2)
			   )
WHERE
	1 = 1;



/*HOLIDAYS: Christmas, US Indpendence, Labor, Memorial, New Years Day, Thanksgiving*/
UPDATE
	[dbo].[Calendar]
SET
	[is_holiday] = [dbo].[IsHoliday]([calendar_date], 'CRD') -- Christmas Day
WHERE
	[is_holiday] <> 1;

UPDATE
	[dbo].[Calendar]
SET
	[is_holiday] = [dbo].[IsHoliday]([calendar_date], 'IND') --American Indpendence Day
WHERE
	[is_holiday] <> 1;

UPDATE
	[dbo].[Calendar]
SET
	[is_holiday] = [dbo].[IsHoliday]([calendar_date], 'LAB') -- Labor Day
WHERE
	[is_holiday] <> 1;

UPDATE
	[dbo].[Calendar]
SET
	[is_holiday] = [dbo].[IsHoliday]([calendar_date], 'MEM') -- Memorial Day
WHERE
	[is_holiday] <> 1;

UPDATE
	[dbo].[Calendar]
SET
	[is_holiday] = [dbo].[IsHoliday]([calendar_date], 'NYD') -- New Years day
WHERE
	[is_holiday] <> 1;

UPDATE
	[dbo].[Calendar]
SET
	[is_holiday] = [dbo].[IsHoliday]([calendar_date], 'THK') -- Thanksgiving Day
WHERE
	[is_holiday] <> 1;

/*OBSERVED HOLIDAYS -- 
if the holiday falls on a saturday, observe the previous friday. if the holiday falls on a sunday, observe on next monday
*/
-- observe on actual date; actual holiday on a weekday
UPDATE
	[Calendar]
SET
	[is_observed_holiday] = 1
WHERE
	[is_holiday] = 1 AND [day_name] NOT IN ( 'Saturday', 'Sunday' );

-- observe on prev. Friday where Saturday is a holiday
UPDATE
	[t1]
SET
	[is_observed_holiday] = 1
FROM
	[Calendar] AS [t1]
JOIN
	[Calendar] AS [t2]
ON
	[t2].[calendar_date] = DATEADD(DAY, 1, [t1].[calendar_date])
WHERE
	[t1].[day_name] = 'Friday' AND [t2].[is_holiday] = 1;

-- observe on next Monday where Sunday was a holiday
UPDATE
	[t1]
SET
	[is_observed_holiday] = 1
FROM
	[Calendar] AS [t1]
JOIN
	[Calendar] AS [t2]
ON
	[t2].[calendar_date] = DATEADD(DAY, -1, [t1].[calendar_date])
WHERE
	[t1].[day_name] = 'Monday' AND [t2].[is_holiday] = 1;


UPDATE
	[Calendar]
SET
	[is_leap_day] = CASE
						WHEN MONTH([calendar_date]) = 2
						AND DAY([calendar_date]) = 29
							 THEN 1
						ELSE 0
					END
WHERE
	1 = 1;

SELECT
	[calendar_number],
	[calendar_date],
	[calendar_date_yyyymmdd],
	[calendar_year],
	[month_of_year],
	[day_of_month],
	[day_name],
	[day_number],
	[is_weekend],
	[day_of_year],
	[week_of_year],
	[month_name],
	[quarter_of_year],
	[yyyymm],
	[is_holiday],
	[is_leap_day]
FROM
	[dbo].[Calendar];