USE [MSD];

IF NOT EXISTS (
	SELECT
		[TABLE_CATALOG],
		[TABLE_SCHEMA],
		[TABLE_NAME],
		[TABLE_TYPE]
	FROM
		[INFORMATION_SCHEMA].[TABLES]
	WHERE
		[TABLE_NAME] = 'Calendar' AND [TABLE_SCHEMA] = 'dbo'
)
BEGIN

	CREATE TABLE [dbo].[Calendar] (
		[calendar_number] BIGINT NOT NULL, -- 0 to 100000
		[calendar_date] DATE NOT NULL, -- January 1 1972 (0) to October 16 2245 (100000)
		[calendar_date_yyyymmdd] CHAR(8) NOT NULL,
		[calendar_year] SMALLINT NOT NULL, -- 1972 to 2245
		[month_of_year] TINYINT NOT NULL, -- 1 to 12
		[day_of_month] TINYINT NOT NULL, -- 1 to 31

		[day_name] VARCHAR(10) NOT NULL, -- Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
		[day_number] TINYINT NOT NULL, -- 0 to 6, 0 = Monday ISO-8601
		[is_weekend] BIT NOT NULL, -- 1 if day_name is Saturday or Sunday, 0 else

		[day_of_year] SMALLINT NOT NULL, -- 1 to 366
		[week_of_year] TINYINT NOT NULL, -- 1 to 53

		[month_name] VARCHAR(10) NOT NULL, -- January, February, March, April, May, June, July, August, September, October, November, December
		[quarter_of_year] TINYINT NOT NULL, -- 1 to 4
		[yyyymm] CHAR(6) NOT NULL,
		[is_holiday] BIT
			DEFAULT 0 NOT NULL,
		[is_observed_holiday] BIT
			DEFAULT 0 NOT NULL,
		[is_leap_day] BIT
			DEFAULT 0 NOT NULL,
		/*KEYS AND CONTRAINTS*/
		PRIMARY KEY ([calendar_number], [calendar_date]),
		UNIQUE ([calendar_date]),
		CHECK ([month_of_year] BETWEEN 1 AND 12),
		CHECK ([day_number] BETWEEN 0 AND 6),
		CHECK ([quarter_of_year] BETWEEN 1 AND 4),
		CHECK ([week_of_year] BETWEEN 1 AND 53),
		CHECK ([day_of_year] BETWEEN 1 AND 366)
	);

	CREATE NONCLUSTERED INDEX [IX_Calendar_CalendarDate]
		ON [dbo].[Calendar] ([calendar_date]);

	CREATE NONCLUSTERED INDEX [IX_Calendar_YYYYMM]
		ON [dbo].[Calendar] ([yyyymm]);

	CREATE NONCLUSTERED INDEX [IX_Calendar_YYYYMM_Date]
		ON [dbo].[Calendar] ([yyyymm], [calendar_date]);

	CREATE NONCLUSTERED INDEX [IX_your_table_date_yyyymmdd]
		ON [dbo].[Calendar] ([calendar_date_yyyymmdd]);



END;

SELECT
	[calendar_number],
	[calendar_date],
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
	[is_observed_holiday],
	[is_leap_day]
FROM
	[dbo].[Calendar];
