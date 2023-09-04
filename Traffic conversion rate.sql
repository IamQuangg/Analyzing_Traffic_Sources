/*  Traffic conversion rates */;
Select
	Count(distinct website_sessions.website_session_id) sessions,
    Count(distinct order_id) orders,
    Count(distinct order_id)/Count(distinct website_sessions.website_session_id) * 100 conv_rt
From website_sessions
	Left Join orders On website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at <'2012-04-14' and
	utm_source = 'gsearch' and
    utm_campaign = 'nonbrand';