-- team1: The name of the first team in the match.
-- team2: The name of the second team in the match.
-- date: The date on which the match was played.
-- hour: The time at which the match started.
-- category: The stage of the tournament in which the game was played (e.g., Group Stage, Round of 16).
-- number of goals team1: The total number of goals scored by team1.
-- number of goals team2: The total number of goals scored by team2.
-- possession team1: The percentage of time team1 had possession of the ball.
-- possession team2: The percentage of time team2 had possession of the ball.
-- possession in contest: The percentage of time the ball was not clearly controlled by either team.
-- goal inside the penalty area team1: Goals scored by team1 from inside the penalty area.
-- goal inside the penalty area team2: Goals scored by team2 from inside the penalty area.
-- goal outside the penalty area team1: Goals scored by team1 from outside the penalty area.
-- goal outside the penalty area team2: Goals scored by team2 from outside the penalty area.
-- assists team1: The number of assists made by team1 players.
-- assists team2: The number of assists made by team2 players.
-- total attempts team1: The total number of goal attempts by team1.
-- total attempts team2: The total number of goal attempts by team2.
-- on target attempts team1: The number of goal attempts by team1 that were on target.
-- on target attempts team2: The number of goal attempts by team2 that were on target.
-- off target attempts team1: The number of goal attempts by team1 that were off target.
-- off target attempts team2: The number of goal attempts by team2 that were off target.
-- left channel team1: Number of plays by team1 on the left side of the field.
-- left channel team2: Number of plays by team2 on the left side of the field.
-- central channel team1: Number of plays by team1 through the center of the field.
-- central channel team2: Number of plays by team2 through the center of the field.
-- right channel team1: Number of plays by team1 on the right side of the field.
-- right channel team2: Number of plays by team2 on the right side of the field.
-- total offers to receive team1: Total times team1 players offered to receive the ball.
-- total offers to receive team2: Total times team2 players offered to receive the ball.
-- receptions between midfield and defensive lines team1: Receptions by team1 players between the opponent's midfield and defensive lines.
-- receptions between midfield and defensive lines team2: Receptions by team2 players between the opponent's midfield and defensive lines.
-- attempted line breaks team1: Total attempted line breaks by team1.
-- completed line breaks team1: Total completed line breaks by team1.
-- attempted defensive line breaks team1: Total defensive line breaks attempted by team1.
-- completed defensive line breaks team1: Total defensive line breaks completed by team1.
-- yellow cards team1: The number of yellow cards received by team1 players.
-- yellow cards team2: The number of yellow cards received by team2 players.
-- red cards team1: The number of red cards received by team1 players.
-- red cards team2: The number of red cards received by team2 players.
-- fouls against team1: The number of fouls committed against team1 players.
-- fouls against team2: The number of fouls committed against team2 players.
-- offsides team1: The number of offsides called against team1.
-- offsides team2: The number of offsides called against team2.
-- corners team1: The number of corner kicks awarded to team1.
-- corners team2: The number of corner kicks awarded to team2.
-- free kicks team1: The number of free kicks awarded to team1.
-- free kicks team2: The number of free kicks awarded to team2.
-- passes team1: The total number of passes attempted by team1.
-- passes team2: The total number of passes attempted by team2.
-- passes completed team1: The total number of passes completed by team1.
-- passes completed team2: The total number of passes completed by team2.
-- crosses team1: The total number of crosses attempted by team1.
-- crosses team2: The total number of crosses attempted by team2.
-- crosses completed team1: The number of crosses completed by team1.
-- crosses completed team2: The number of crosses completed by team2.
-- switches of play completed team1: The number of successful switches of play made by team1.
-- switches of play completed team2: The number of successful switches of play made by team2.
-- goal preventions team1: The total number of goal preventions (saves) by team1.
-- goal preventions team2: The total number of goal preventions (saves) by team2.
-- forced turnovers team1: The number of turnovers forced by team1.
-- forced turnovers team2: The number of turnovers forced by team2.
-- defensive pressures applied team1: The number of defensive pressures applied by team1.
-- defensive pressures applied team2: The number of defensive pressures applied by team2.

-- Total Goals by Each Team Across All Matches
SELECT
team,
SUM(number_of_goals) AS total_goals
FROM (
SELECT team1 AS team, CAST([number_of_goals_team1] AS INT) AS number_of_goals
FROM dbo.Fifa_world_cup_matches
UNION ALL
SELECT team2 AS team, CAST([number_of_goals_team2] AS INT)
FROM dbo.Fifa_world_cup_matches
) AS goals
GROUP BY team
ORDER BY total_goals DESC;

-- Average Possession Percentage of Winning Teams
SELECT 
    team,
    AVG(possession_percentage) AS avg_possession
FROM (
    SELECT 
        team1 AS team,
        CAST(REPLACE([possession_team1], '%', '') AS FLOAT) AS possession_percentage
    FROM Fifa_world_cup_matches
    WHERE CAST([number_of_goals_team1] AS INT) > CAST([number_of_goals_team2] AS INT)
    UNION ALL
    SELECT 
        team2 AS team,
        CAST(REPLACE([possession_team2], '%', '') AS FLOAT)
    FROM Fifa_world_cup_matches
    WHERE CAST([number_of_goals_team2] AS INT) > CAST([number_of_goals_team1] AS INT)
) AS possession
GROUP BY team
ORDER BY avg_possession DESC;

-- Top 5 Teams with Most Defensive Actions (Blocks and Tackles)
SELECT TOP 5 
    team,
    SUM(defensive_actions) AS total_defensive_actions
FROM (
    SELECT 
        team1 AS team,
        CAST([goal_preventions_team1] AS INT) + CAST([forced_turnovers_team1] AS INT) AS defensive_actions
    FROM fifa_world_cup_matches
    UNION ALL
    SELECT 
        team2 AS team,
        CAST([goal_preventions_team2] AS INT) + CAST([forced_turnovers_team2] AS INT)
    FROM fifa_world_cup_matches
) AS defenses
GROUP BY team
ORDER BY total_defensive_actions DESC;

-- Average Shots on Target Per Game by Each Team
SELECT 
    team,
    AVG(shots_on_target) AS avg_shots_on_target
FROM (
    SELECT 
        team1 AS team,
        CAST([on_target_attempts_team1] AS INT) AS shots_on_target
    FROM fifa_world_cup_matches
    UNION ALL
    SELECT 
        team2 AS team,
        CAST([on_target_attempts_team2] AS INT)
    FROM fifa_world_cup_matches
) AS shots
GROUP BY team
ORDER BY avg_shots_on_target DESC;

-- Teams with Highest Fouls Committed Per Match
SELECT 
    team,
    AVG(fouls_committed) AS avg_fouls
FROM (
    SELECT 
        team1 AS team,
        CAST([fouls_against_team2] AS INT) AS fouls_committed
    FROM fifa_world_cup_matches
    UNION ALL
    SELECT 
        team2 AS team,
        CAST([fouls_against_team1] AS INT)
    FROM fifa_world_cup_matches
) AS fouls
GROUP BY team
ORDER BY avg_fouls DESC;

-- Teams with Most Successful Crosses
SELECT 
    team,
    SUM(successful_crosses) AS total_successful_crosses
FROM (
    SELECT 
        team1 AS team,
        CAST([crosses_completed_team1] AS INT) AS successful_crosses
    FROM fifa_world_cup_matches
    UNION ALL
    SELECT 
        team2 AS team,
        CAST([crosses_completed_team2] AS INT)
    FROM fifa_world_cup_matches
) AS crosses
GROUP BY team
ORDER BY total_successful_crosses DESC;

-- Top 5 Matches with Highest Defensive Pressures
SELECT TOP 5
    team1,
    team2,
    CAST([defensive_pressures_applied_team1] AS INT) + CAST([defensive_pressures_applied_team2] AS INT) AS total_defensive_pressures
FROM fifa_world_cup_matches
ORDER BY total_defensive_pressures DESC;

-- Teams with the Highest Efficiency in Scoring (Goals per Shot on Target)
SELECT 
    team,
    CAST(SUM(goals) AS FLOAT) / NULLIF(SUM(shots_on_target), 0) AS scoring_efficiency
FROM (
    SELECT 
        team1 AS team,
        CAST([number_of_goals_team1] AS INT) AS goals,
        CAST([on_target_attempts_team1] AS INT) AS shots_on_target
    FROM fifa_world_cup_matches
    UNION ALL
    SELECT 
        team2 AS team,
        CAST([number_of_goals_team2] AS INT),
        CAST([on_target_attempts_team2] AS INT)
    FROM fifa_world_cup_matches
) AS scoring
GROUP BY team
HAVING SUM(shots_on_target) > 0
ORDER BY scoring_efficiency DESC;

-- Average Pass Completion Rate by Team Across All Matches
SELECT 
    team,
    CAST(SUM(passes_completed) AS FLOAT) / NULLIF(SUM(total_passes), 0) AS avg_pass_completion_rate
FROM (
    SELECT 
        team1 AS team,
        CAST([passes_completed_team1] AS INT) AS passes_completed,
        CAST([passes_team1] AS INT) AS total_passes
    FROM fifa_world_cup_matches
    UNION ALL
    SELECT 
        team2 AS team,
        CAST([passes_completed_team2] AS INT),
        CAST([passes_team2] AS INT)
    FROM fifa_world_cup_matches
) AS passing
GROUP BY team
ORDER BY avg_pass_completion_rate DESC;

-- Top Matches with the Highest Combined Yellow and Red Cards
SELECT 
    team1,
    team2,
    (CAST([yellow_cards_team1] AS INT) + CAST([yellow_cards_team2] AS INT) +
     CAST([red_cards_team1] AS INT) + CAST([red_cards_team2] AS INT)) AS total_cards
FROM fifa_world_cup_matches
ORDER BY total_cards DESC







