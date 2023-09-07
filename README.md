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
  ## 1.3. Bid Optimization For Paid Traffic
  	Select
		website_sessions.device_type,
    	Count(distinct website_sessions.website_session_id) Sessions,
    	Count(distinct orders.order_id) Orders,
    	Count(distinct orders.order_id) / Count(distinct website_sessions.website_session_id)*100 conv_rt
	From website_sessions
		Left join orders
			On website_sessions.website_session_id = orders.website_session_id
	Where website_sessions.created_at < '2012-05-11'
		And utm_source = 'gsearch'
    	And utm_campaign = 'nonbrand'
	Group By 
		website_sessions.device_type;
  ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/5f623e75-1403-4c80-ae6b-32cab257b8bf)

  Based on data provided, desktop performs way better than mobile and we should not run the same bid for desktop and mobile traffic, often in paid search campaigns.
  We should increase bids for desktop specific traffic beacause it performs much better.
 ## 2. Analyzing Website Performance
 * Phân Tích Nội Dung Hàng Đầu Trên Trang Web (Analyzing Top Website Content)

   Phân tích nội dung trang web liên quan đến việc hiểu rõ những trang nào được người dùng xem nhiều nhất, để xác định nơi cần tập trung để cải trang web của bạn.
## 2.1. Xác định Các Trang Web Phổ Biến Nhất (Top Website Pages)
	Select 
		pageview_url,
    	Count(website_session_id) sessions
	From website_pageviews
	Where created_at <'2012-06-09'
	Group By
		pageview_url
	Order By sessions DESC
 ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/57bbbdcb-367a-42cc-89ef-d43b61e4da2a)

 Ta có thể thấy "home" nhận được phần lớn lượt xem trang web trong khoảng thời gian này, tiếp theo là các "products" và "Original Mr. Fuzzy". "Home" và "Product" page là 
 những trang thu hút nhiều người dùng nhất. Tuy nhiên, "top website pages" chỉ tập trung vào danh sách các trang web phổ biến nhất hoặc có hiệu suất tốt nhất trên toàn bộ 
 trang web, do đó chúng ta sẽ đi tìm tiểu thêm trang web nào mà người dùng thường dùng để bắt đầu phiên truy cập.
 ## 2.2. Xác định Các Trang Đầu Vào Phổ Biến Nhất (Top Entry Pages)
 	create temporary table first_pageview1
	Select
		 website_session_id,
   	 	 min(website_pageview_id) min_pv_id
	From website_pageviews
	Group by website_session_id;
	Select 
		pageview_url,
    	Count(first_pageview1.website_session_id) sessions_hitting_this_landing_page
	From first_pageview1
		Left Join website_pageviews
			On first_pageview1.min_pv_id = website_pageviews.website_pageview_id
	Where website_pageviews.created_at < '2012-06-12'
	Group by 
		pageview_url
  ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/37f46bec-d6d5-4f73-83ee-a72495dafac2)

  "Home" là trang mà có lượng người dùng truy cập lần đầu tiên nhiều nhất. Do đó, ta nên dành thời gian để đảm bảo rằng trang này có hiệu suất tốt nhất để thỏa mãn 
  trải nghiệm người dùng.


  


  
