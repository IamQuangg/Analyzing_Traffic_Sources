# I. The Situation
  You've just been hired as an Ecommerce Data Analyst for ABC Company, an online retailer which has just launched their first product.

  As the member of the startup team, you will work with the CEO, the Marketing Director, and the Website Manager to help steer the business.
  First of all, you will analyze and optimize marketing channels, measure and test website conversion performance, and use data to understand 
  the impact of new product launches.

  Use SQL to:
  + Access and explore the database.
  + Analyze and optimize the business marketing channels, website, and product.
## 1. Analyzing Top Traffic Sources
  Traffic sources analysis is about understanding where customers are coming from and which channels are driving the highest quality traffic.
    
    Select
	    utm_source,
      utm_campaign,
      http_referer,
      count(distinct website_session_id) Sessions
    From website_sessions
    Where created_at < '2012-04-12'
    Group by
	    utm_source,
      utm_campaign,
      http_referer
    Order by
	    Sessions DESC
  ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/bbc4b35f-4732-4b0d-bd4e-4478f1f6424f)
  
  We can see that G search Non-brand is the most important thing for us to be focusing on right now.
  ## 1.1. Analyzing Traffic Sources Conversion Rates
  Base on calculating above, gsearch nonbrand is major traffic, but we need to understand if those sessions are driving sales. We can calculate
  the conversion rate (CVR) from sessions to orders

    Select
	    Count(distinct website_sessions.website_session_id) sessions,
      Count(distinct order_id) orders,
      Count(distinct order_id)/Count(distinct website_sessions.website_session_id) * 100 conv_rt
    From website_sessions
	    Left Join orders 
         On website_sessions.website_session_id = orders.website_session_id
    Where website_sessions.created_at <'2012-04-14' 
      And
	      utm_source = 'gsearch'
      And
        utm_campaign = 'nonbrand';
  ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/8c965c46-f79b-404f-8090-5291efda594f)
  
  The conversion rate is quite low. Base on this analysis, we'll need to dial down search bid a bit. we're over spending based on the current conversion rate.
  ## 1.2. Bid Optimization & Trend Analysis
  Analyzing for bid optimization is about understanding the vablue of various segment of paid traffic, so that you can optimize your marketing budget.

    Select
	      Min(date(created_at)) week_start,
          Count(distinct website_session_id) sessions
    From website_sessions
    Where created_at < '2012-05-10'
	    And utm_source = 'gsearch'
        And utm_campaign = 'nonbrand'
    Group By
	    Year(created_at),
	    week(created_at)
  ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/34e9a135-1a5a-446f-a987-01b1757d117f)

  We were around 900 over 1000 and now we're down in the roughly 600 to 680 range for the last four weeks. The reason is that we have decreased the bid for this
  because the conversion rate is low as we analyzed above.


  


  
