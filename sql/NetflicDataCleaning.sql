CREATE TABLE [dbo].[netflix_raw](
	[show_id] [varchar](10) primary key,
	[type] [varchar](10)NULL,
	[title] [nvarchar](200) NULL,
	[director] [varchar] (400)NULL,
	[cast] [varchar](1000)NULL,
	[country] [varchar] (150) NULL,
	[date_added] [varchar] (20)NULL,
	[release_year] [int] NULL,
	[rating] [varchar](10) NULL,
	[duration] [varchar](10) NULL,
	[listed_in][varchar] (100) NULL,
	[description][varchar] (500) NULL
) 
GO

Truncate table netflix_raw;
SELECT * from netflix_raw where show_id='s5023'

select show_id, count(*) from netflix_raw group by show_id having count(*)>1
SELECT * from netflix_raw where concat(title, type) in (
SELECT concat(title,type) FROM netflix_raw group by title, type having count(*) > 1) order by title;

WITH CTE as (
select * , ROW_NUMBER() over(partition by title, type order by show_id) as rn
from netflix_raw)
select * from cte where rn = 1;

With CTE as (
SELECT *, ROW_NUMBER() over(partition by title, type order by show_id) as rn from netflix_raw)
select * from cte where rn = 1;

--creating table which list all directors
SELECT show_id, trim(value) as genre
into netflix_genre
from netflix_raw
cross apply string_split(listed_in, ',')

select * from netflix_directors;
select * from netflix_country;
select * from netflix_genre;

select show_id, country from netflix_raw where country is null;

select * from netflix_country where show_id = 's1001';

--we take director name and the country of their work released.
select director, country from netflix_country nc inner join netflix_directors nd on nc.show_id = nd.show_id group by director, country
order by director;

insert into netflix_country
select show_id, m.country
from netflix_raw nr
inner join (
select director, country from netflix_country nc inner join netflix_directors nd on nc.show_id = nd.show_id group by director, country)
m on nr.director =m.director
where nr.country is null;

select * from netflix_raw;

with cte as (
select *, ROW_NUMBER() over(partition by title, type order by show_id) as rn
from netflix_raw)
select show_id, type, title, cast(date_added as date) as date_added, release_year,
rating, case when duration is null then rating else duration end as duration, description into netflix from cte