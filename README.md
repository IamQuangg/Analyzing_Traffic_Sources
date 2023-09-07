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
 ## 2. Phân tích Hiệu suất Trang Web
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

* Landing Page Performance & Testing

  "Landing Page Performance & testing" là về việc hiểu về hiệu suất của các trang đích quan trọng của bạn và sau đó tiến hành kiểm tra để cải thiện kết quả.
  ## 2.3. Tính Toán Tỉ Lệ Thoát (Bounce Rate)

		Create temporary table first_pageviews
		Select
			website_session_id,
	 		Min(website_pageview_id) min_pageview_id
		From website_pageviews
		Where created_at < '2012-06-14'
		Group By
			website_session_id;
	    
		Create temporary table session_w_landing_home_page1
		Select 
			first_pageviews.website_session_id,
	 		website_pageviews.pageview_url landing_page
		From first_pageviews
			left join website_pageviews
				on website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
	 	Where
			website_pageviews.pageview_url = '/home';
	    
		Create temporary table bounced_sessions
		Select 
			session_w_landing_home_page1.website_session_id,
	 		session_w_landing_home_page1.landing_page,
	 		Count(website_pageviews.website_pageview_id) count_of_page_view
		From session_w_landing_home_page1
			Left join website_pageviews
				On website_pageviews.website_session_id = session_w_landing_home_page1.website_session_id
		Group By
			session_w_landing_home_page1.website_session_id,
	 		session_w_landing_home_page1.landing_page
		Having 
		 	Count(website_pageviews.website_pageview_id) =1;
	 	Select
			Count(distinct session_w_landing_home_page1.website_session_id) total_sessions,
	 		Count(distinct bounced_sessions.website_session_id) bounced_session,
	 		Count(distinct bounced_sessions.website_session_id) / Count(distinct session_w_landing_home_page1.website_session_id) bounced_rt
		From session_w_landing_home_page1
			left join bounced_sessions
				on session_w_landing_home_page1.website_session_id = bounced_sessions.website_session_id
  ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/a33af91d-370c-4e46-a0ee-c9eedefcd281)

  Chúng ta có thể thấy với tỷ lệ thoát 59.18%, điều này có nghĩa là khoảng 59.18% người truy cập đã rời khỏi trang web sau khi chỉ xem một trang duy nhất mà không thực
  hiện thêm bất kỳ hành động nào khác. Tỷ lệ thoát cao có thể là dấu hiệu cho thấy cần phải xem xét và tối ưu hóa trải nghiệm người dùng trên trang web để giảm tỷ lệ thoát
  và tăng khả năng tương tác của người dùng.
  ## 2.4. Phân Tích Xu Hướng Trang Đích (Landing Page)

	 	create temporary table sessions_w_min_pv
		select
			website_sessions.website_session_id,
	 		Min(website_pageviews.website_pageview_id) first_pageview_id,
	 		Count(website_pageviews.website_pageview_id) count_pageviews
		From website_sessions
		Left Join website_pageviews
			On website_pageviews.website_session_id = website_sessions.website_session_id
		Where website_sessions.created_at > '2012-06-01'
			And website_sessions.created_at <'2012-08-31'
			And website_sessions.utm_source = 'gsearch'
			And website_sessions.utm_campaign = 'nonbrand'
		Group by
			website_sessions.website_session_id;
	    
		Create temporary table session_w_count_lander    
		Select 
			sessions_w_min_pv.website_session_id,
		 	sessions_w_min_pv.first_pageview_id,
	 		sessions_w_min_pv.count_pageviews,
		 	website_pageviews.pageview_url landing_page,
	 		website_pageviews.created_at session_created_at
		From sessions_w_min_pv
		Left Join website_pageviews
			On website_pageviews.website_pageview_id = sessions_w_min_pv.first_pageview_id;
	        
		Select
			min(date(session_created_at)) week_start_date,
			count(distinct website_session_id) total_sessions,
			count(distinct case when count_pageviews = 1 then website_session_id Else Null End) bounced_sessions,
			count(distinct case when count_pageviews = 1 then website_session_id Else Null End) /  count(distinct website_session_id) * 100 bounced_rt,
			count(distinct case when landing_page = '/home' then website_session_id else Null End) home_sessions,
			count(distinct case when landing_page = '/lander-1' then website_session_id else null end) lander_sessions
		From session_w_count_lander  
		Group by
			yearweek(session_created_at)
  ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/dc430d28-2599-4e16-b6bf-1b737f51d382)

  Chúng ta có thể thấy rằng tỷ lệ thoát đang giảm theo thời gian, điều này có thể là tín hiệu tốt bởi vì có thể trang web có trải nghiệm người dùng tốt hơn,
  hoặc nội dung hấp dẫn hơn, hoặc giao diện đẹp hơn. Dù là nguyên nhân nào thì cũng cho thấy trang web đang đi đúng hướng với thị hiếu của người dùng.
  



  

  


  
