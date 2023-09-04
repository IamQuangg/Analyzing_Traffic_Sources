select 
	device_type,
    count(distinct website_sessions.website_session_id) sessions,
    count(distinct order_id) orders,
    count(distinct order_id) /  count(distinct website_sessions.website_session_id) * 100 conv_rt
from website_sessions
	Left join orders On website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < '2012-05-11'
And utm_source = 'gsearch'
And utm_campaign = 'nonbrand'
Group By 
	device_type