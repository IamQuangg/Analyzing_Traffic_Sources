Select 
	week(created_at) wk,
	Min(date(created_at)) week_start_date,
    Count(Case When device_type = 'desktop' then website_session_id else null end)desktop_sessions,
    count( case when device_type = 'mobile' then website_session_id else null end) mobile_sessions
From website_sessions	
Where utm_source = 'gsearch'
And utm_campaign = 'nonbrand'
And website_sessions.created_at >'2012-04-15'
And website_sessions.created_at < '2012-06-09'
Group By week(created_at)