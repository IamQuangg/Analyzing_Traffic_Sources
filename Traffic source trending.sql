Select
	-- Year(created_at) yr,
    -- week(created_at) wk,
	Min(date(created_at)) week_start,
    Count(distinct website_session_id) sessions
from website_sessions
where created_at < '2012-05-10'
	And utm_source = 'gsearch'
    And utm_campaign = 'nonbrand'
Group By
	Year(created_at),
	week(created_at)