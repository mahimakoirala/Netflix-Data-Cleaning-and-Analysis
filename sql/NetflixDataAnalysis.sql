
/*1 for each director count the no of movies and tv shows created by them for directors who have created tv shows and movies both */
SELECT nd.director,
count(distinct case when n.type = 'movie' then n.show_id end) as no_of_movies 
, count(distinct case when n.type = 'TV show' then n.show_id end) as no_of_tvshow
from netflix n
inner join netflix_directors nd on n.show_id = nd.show_id
group by nd.director
having count(distinct n.type) > 1
order by distinct_type desc


select * from netflix_raw where director like 'will allen';

-- 2. which country has highest number of comedy movies
select count(country) from netflix_raw where max(count(listed_in LIKE '%comedies%' ));

select country, count(*) as count_comedy_movies 
from netflix_raw
where listed_in like '%comedies%' and type = 'movie'
group by country
order by count_comedy_movies desc;


select * from netflix_directors
select * from netflix
select * from netflix_raw
select * from netflix_genre

--3.For each year, as per date added to netflix, which director has max no of movies released. 
with cte as (
select nd.director, YEAR(date_added) as date_year, count(n.show_id) as no_of_movies
from netflix n
inner join netflix_directors nd on n.show_id = nd.show_id
where type = 'Movie'
group by nd.director,Year(date_added)
)
, cte2 as (
select *, ROW_NUMBER() over(partition by date_year order by no_of_movies desc, director) as rn
from cte
--order by date_year, no_of_movies desc
)
select * from cte2 where rn = 1

--4. What is the average duration of movie in each genre.
SELECT ng.genre, avg(cast(REPLACE(n.duration, ' min','') AS int)) as avg_duration
from netflix_genre ng
inner join netflix n on ng.show_id = n.show_id
where type = 'Movie'
group by ng.genre

--5. find the list of directors who have created horror and comedy movies both. 
--display director name along with number of comedy and horror movies directed by them
SELECT nd.director
, count(distinct case when ng.genre = 'Comedies' then n.show_id end) as no_of_comedy
, count(distinct case when ng.genre = 'Horror Movies' then n.show_id end) as no_of_horror
from netflix n
inner join netflix_genre ng on n.show_id = ng.show_id
inner join netflix_directors nd on n.show_id = nd.show_id
where type = 'Movie' and ng.genre in ('Comedies', 'Horror Movies')
group by nd.director
having count(distinct ng.genre)=2

