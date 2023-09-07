# I. Bối Cảnh
  Bạn vừa mới được tuyển dụng làm Chuyên viên Phân tích Dữ liệu Thương mại điện tử cho Công ty ABC, một nhà bán lẻ trực tuyến vừa ra mắt sản phẩm đầu tiên của họ.

  Là thành viên của đội khởi nghiệp, bạn sẽ làm việc cùng CEO, Giám đốc Marketing và Quản lý Trang web để hỗ trợ trong việc điều hành doanh nghiệp.
  Trước hết, bạn sẽ phân tích và tối ưu hóa các kênh tiếp thị, đo lường và kiểm tra hiệu suất chuyển đổi trên trang web và sử dụng dữ liệu để hiểu
  tác động của việc ra mắt sản phẩm mới

  Sử dụng SQL để:
  + Truy cập và khám phá cơ sở dữ liệu.
  + Phân tích và tối ưu hóa các kênh tiếp thị kinh doanh, trang web và sản phẩm.
## 1. Phân tích Các Lượng Truy Cập Hàng Đầu
  Phân tích nguồn lưu lượng là về việc hiểu xem khách hàng đến từ đâu và các kênh nào đang đưa ra lưu lượng có chất lượng cao nhất.
    
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
  
  Chúng ta có thể thấy rằng tìm kiếm google  và "Non-brand" là 2 nguồn chúng ta nên tập trung bởi vì chúng có lượng truy cập nhiều nhất.
  ## 1.1. Phân Tích Tỷ Lệ Chuyển Đổi
  Dựa vào việc tính toán ở trên, tìm kiếm Google không liên quan đến thương hiệu là nguồn lưu lượng chính, nhưng chúng ta cần hiểu xem những phiên truy 
  cập đó có đang thúc đẩy doanh số bán hàng hay không. Chúng ta có thể tính toán tỷ lệ chuyển đổi (CVR) từ phiên truy cập sang đơn hàng.

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
  
  Tỷ lệ chuyển đổi khá thấp. Dựa trên phân tích này, chúng ta sẽ cần giảm mức chi tiêu cho quảng cáo tìm kiếm một chút. Chúng ta đang tiêu quá nhiều dựa 
  trên tỷ lệ chuyển đổi hiện tại.
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
   ## 2.5. Xây Dựng Hệ Thống Chuyển Đổi (Conversion Funnel)
  Phân tích hệ thống chuyển đổi là về việc hiểu và tối ưu hóa từng bước trải nghiệm của người dùng trong hành trình của họ đến việc mua sản phẩm của bạn.

	 	Create temporary table sessions_level_made_it
		Select
			website_session_id,
			Max(product_page) product_made_it,
	 		Max(mrfuzzy_page) mrfuzzy_made_it,
	 		Max(cart_page) cart_made_it,
			Max(shipping_page) shipping_made_it,
	 		Max(billing_page) billing_made_it,
			Max(thankyou_page) thankyou_made_it
		From(
		Select
			website_sessions.website_session_id,
	 		website_pageviews.pageview_url,
	 		website_pageviews.created_at pageview_created_at,
		 	Case when pageview_url = '/products' then 1 else 0 end product_page,
	 		Case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end mrfuzzy_page,
	 		Case when pageview_url = '/cart' then 1 else 0 end cart_page,
	 		Case when pageview_url = '/shipping' then 1 else 0 end shipping_page,
	 		Case When pageview_url ='/billing' then 1 else 0 end billing_page,
	 		Case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end thankyou_page
		From website_sessions
			Left join website_pageviews
				On website_pageviews.website_session_id = website_sessions.website_session_id
		Where website_sessions.created_at between '2012-08-05' and '2012-09-05'
			And website_sessions.utm_source = 'gsearch'
	 		And website_sessions.utm_campaign ='nonbrand'
		Order by
			website_sessions.website_session_id
		) as pageview_level
		group by
			website_session_id;
	    
	 	Select
			Count(distinct website_session_id) sessions,
	 		Count(distinct case when product_made_it = 1 then website_session_id else null end) to_products,
	 		Count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end) to_mrfuzzy,
			Count(distinct case when cart_made_it= 1 then website_session_id else null end) to_cart,
	        	Count(distinct case when shipping_made_it = 1 then website_session_id else null end) to_shipping,
	        	Count(distinct case when billing_made_it = 1 then website_session_id else null end) to_billing,
	        	Count(distinct case when thankyou_made_it = 1 then website_session_id else null end) to_thankyou
		From sessions_level_made_it;
	    
	    Select
			Count(distinct case when product_made_it = 1 then website_session_id else null end) / Count(distinct website_session_id) lander_click_rt,
		 	Count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end) /
			Count(distinct case when product_made_it = 1 then website_session_id else null end) mr_fuzzy_click_rt,
			Count(distinct case when cart_made_it= 1 then website_session_id else null end) /
			Count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end) cart_click_rt,
			Count(distinct case when shipping_made_it = 1 then website_session_id else null end) /
			Count(distinct case when cart_made_it= 1 then website_session_id else null end) shipping_click_rt,
		 	Count(distinct case when billing_made_it = 1 then website_session_id else null end) /
		 	Count(distinct case when shipping_made_it = 1 then website_session_id else null end) billing_click_rt,
		 	Count(distinct case when thankyou_made_it = 1 then website_session_id else null end) /
		 	Count(distinct case when billing_made_it = 1 then website_session_id else null end) thankyou_click_rt
 	   From sessions_level_made_it;
  ![image](https://github.com/IamQuangg/Analyzing_Traffic_Sources/assets/128073066/663edce9-f9f0-45ec-901c-c1545c4ce766)

  Từ dữ liệu trên chúng ta nên tập trung vào lander, cart, và thankyou page do những trang này có tỷ lệ chuyển đổi khá thấp so với các trang khác. Để có gia tăng tỷ lệ
  chuyển đổi chúng ta nên cải thiện trải nghiệm người dùng, tối ưu hóa trang web, tối ưu hóa trình điều hướng, cải thiện nội dung, hoặc thậm chí là thay đổi chiến dịch tiếp thị
  để thu hút khách hàng tiềm năng chất lượng cao hơn.

	  



  

  


  
