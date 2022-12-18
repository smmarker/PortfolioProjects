SELECT *
FROM dbo.in$

/*avg atp ranking of winners*/
SELECT TOURNAMENT,
AVG(WINNER_ATP_RANKING) as AVG_ATP_RANK
FROM dbo.in$
GROUP BY TOURNAMENT

/*avg atp ranking of runners-up*/
SELECT TOURNAMENT,
AVG(RUNNER_UP_ATP_RANKING) AS AVG_ATP_RANK_RU
FROM dbo.in$
GROUP BY TOURNAMENT

/*avg atp ranking of winners and runners-up by tournament*/
SELECT TOURNAMENT,
AVG(WINNER_ATP_RANKING) as AVG_ATP_RANK_W,
AVG(RUNNER_UP_ATP_RANKING) AS AVG_ATP_RANK_RU
FROM dbo.in$
WHERE TOURNAMENT IS NOT NULL
GROUP BY TOURNAMENT

/*right handed vs. left handed winners*/
SELECT TOURNAMENT,
SUM(CASE WHEN WINNER_L_OR_R='right' then 1 else 0 end) as WINNER_R,
SUM(CASE WHEN WINNER_L_OR_R='left' then 1 else 0 end) as WINNER_L
FROM dbo.in$
WHERE TOURNAMENT IS NOT NULL
GROUP BY TOURNAMENT

/*winners and prize money for each tournament*/
SELECT WINNER,
TOURNAMENT,
WINNER_PRIZE, 
YEAR
FROM dbo.in$
WHERE WINNER_PRIZE IS NOT NULL
ORDER BY WINNER_PRIZE DESC

/*total prize money by individual winner*/
SELECT WINNER,
SUM(WINNER_PRIZE) AS PRIZE_MONEY
FROM dbo.in$
WHERE WINNER_PRIZE IS NOT NULL
GROUP BY WINNER
ORDER BY SUM(WINNER_PRIZE) DESC

/*count of winners by country*/
SELECT WINNER_NATIONALITY,
count(WINNER_NATIONALITY) as no_country_winners 
FROM dbo.in$
group by WINNER_NATIONALITY
order by no_country_winners DESC

/*total prize money per year*/
SELECT SUM(WINNER_PRIZE) AS TOTAL_PRIZE_MONEY,
YEAR
FROM dbo.in$
WHERE WINNER_PRIZE IS NOT NULL
GROUP BY YEAR
ORDER BY TOTAL_PRIZE_MONEY DESC

/*most losses to same opponent in a GS final*/
SELECT RUNNER_UP, 
COUNT(RUNNER_UP) AS lost_to,
WINNER
from dbo.in$
group by runner_up, winner
order by lost_to DESC

/*total times as runner-up exceeds 5*/
SELECT runner_up,
count(RUNNER_UP) AS SECOND_PLACE
from dbo.in$
WHERE RUNNER_UP IS NOT NULL
GROUP BY RUNNER_UP
HAVING COUNT(RUNNER_UP)>5

/*total times as runner_up where times as runner-up exceeds 5*/
SELECT TOURNAMENT,
SUM(case when runner_up='Ivan Lendl' THEN 1 ELSE 0 END) as 'Lendl',
SUM(case when runner_up='Novak Djokovic' THEN 1 ELSE 0 END) as 'Nole',
SUM(case when runner_up='Roger Federer' THEN 1 ELSE 0 END) as 'Federer',
SUM(case when runner_up='Rafael Nadal' THEN 1 ELSE 0 END) as 'Nadal',
SUM(case when runner_up='Andy Murray' THEN 1 ELSE 0 END) as 'Murray',
SUM(case when runner_up='Andre Agassi' Then 1 ELSE 0 END) as 'Agassi',
SUM(case when runner_up='Fred Stolle' THEN 1 ELSE 0 END) as 'Stolle',
SUM(case when runner_up='Jimmy Connors' THEN 1 ELSE 0 END) as 'Connors',
SUM(case when runner_up='Ken Rosewall' THEN 1 ELSE 0 END) as 'Rosewall',
SUM(case when runner_up='Rod Laver' THEN 1 ELSE 0 END) as 'Laver'
FROM dbo.in$
WHERE TOURNAMENT IS NOT NULL
GROUP BY TOURNAMENT;

/*total times as runner_up vs winner where times as runner-up exceeds 5*/
SELECT
SUM(case when runner_up='Ivan Lendl' THEN 1 ELSE 0 END) as 'Lendl',
SUM(case when runner_up='Novak Djokovic' THEN 1 ELSE 0 END) as 'Nole',
SUM(case when runner_up='Roger Federer' THEN 1 ELSE 0 END) as 'Federer',
SUM(case when runner_up='Rafael Nadal' THEN 1 ELSE 0 END) as 'Nadal',
SUM(case when runner_up='Andy Murray' THEN 1 ELSE 0 END) as 'Murray',
SUM(case when runner_up='Andre Agassi' Then 1 ELSE 0 END) as 'Agassi',
SUM(case when runner_up='Fred Stolle' THEN 1 ELSE 0 END) as 'Stolle',
SUM(case when runner_up='Jimmy Connors' THEN 1 ELSE 0 END) as 'Connors',
SUM(case when runner_up='Ken Rosewall' THEN 1 ELSE 0 END) as 'Rosewall',
SUM(case when runner_up='Rod Laver' THEN 1 ELSE 0 END) as 'Laver'
FROM dbo.in$
WHERE TOURNAMENT IS NOT NULL
select
SUM(case when winner='Ivan Lendl' THEN 1 ELSE 0 END) as 'Lendl',
SUM(case when winner='Novak Djokovic' THEN 1 ELSE 0 END) as 'Nole',
SUM(case when winner='Roger Federer' THEN 1 ELSE 0 END) as 'Federer',
SUM(case when winner='Rafael Nadal' THEN 1 ELSE 0 END) as 'Nadal',
SUM(case when winner='Andy Murray' THEN 1 ELSE 0 END) as 'Murray',
SUM(case when winner='Andre Agassi' Then 1 ELSE 0 END) as 'Agassi',
SUM(case when winner='Fred Stolle' THEN 1 ELSE 0 END) as 'Stolle',
SUM(case when winner='Jimmy Connors' THEN 1 ELSE 0 END) as 'Connors',
SUM(case when winner='Ken Rosewall' THEN 1 ELSE 0 END) as 'Rosewall',
SUM(case when winner='Rod Laver' THEN 1 ELSE 0 END) as 'Laver'
FROM dbo.in$
WHERE TOURNAMENT IS NOT NULL

/*total times as runner_up vs winner where times as runner-up exceeds 5 grouped by tournament*/
SELECT tournament AS tournament_finalist,
SUM(case when runner_up='Ivan Lendl' THEN 1 ELSE 0 END) as 'Lendl',
SUM(case when runner_up='Novak Djokovic' THEN 1 ELSE 0 END) as 'Nole',
SUM(case when runner_up='Roger Federer' THEN 1 ELSE 0 END) as 'Federer',
SUM(case when runner_up='Rafael Nadal' THEN 1 ELSE 0 END) as 'Nadal',
SUM(case when runner_up='Andy Murray' THEN 1 ELSE 0 END) as 'Murray',
SUM(case when runner_up='Andre Agassi' Then 1 ELSE 0 END) as 'Agassi',
SUM(case when runner_up='Fred Stolle' THEN 1 ELSE 0 END) as 'Stolle',
SUM(case when runner_up='Jimmy Connors' THEN 1 ELSE 0 END) as 'Connors',
SUM(case when runner_up='Ken Rosewall' THEN 1 ELSE 0 END) as 'Rosewall',
SUM(case when runner_up='Rod Laver' THEN 1 ELSE 0 END) as 'Laver'
FROM dbo.in$
WHERE TOURNAMENT IS NOT NULL
group by tournament
select tournament AS tournament_winner, 
SUM(case when winner='Ivan Lendl' THEN 1 ELSE 0 END) as 'Lendl',
SUM(case when winner='Novak Djokovic' THEN 1 ELSE 0 END) as 'Nole',
SUM(case when winner='Roger Federer' THEN 1 ELSE 0 END) as 'Federer',
SUM(case when winner='Rafael Nadal' THEN 1 ELSE 0 END) as 'Nadal',
SUM(case when winner='Andy Murray' THEN 1 ELSE 0 END) as 'Murray',
SUM(case when winner='Andre Agassi' Then 1 ELSE 0 END) as 'Agassi',
SUM(case when winner='Fred Stolle' THEN 1 ELSE 0 END) as 'Stolle',
SUM(case when winner='Jimmy Connors' THEN 1 ELSE 0 END) as 'Connors',
SUM(case when winner='Ken Rosewall' THEN 1 ELSE 0 END) as 'Rosewall',
SUM(case when winner='Rod Laver' THEN 1 ELSE 0 END) as 'Laver'
FROM dbo.in$
WHERE TOURNAMENT IS NOT NULL
group by tournament

