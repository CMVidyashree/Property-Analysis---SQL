create database project;
use project;


select * from dallas_availability;
select * from dallas_hosts;
select * from dallas_listings;


select * from dallas_availability where price != adjusted_price;


select h.host_id,h.host_name, avg(l.review_scores_rating) rating , count(l.id) count_ 
from dallas_hosts h inner join dallas_listings l on h.host_id = l.host_id group by h.host_id, h.host_name order by count_ desc;



----. Analyze different metrics to draw the distinction between the different types of property along with their 
------price listings(bucketize them within 3-4 categories basis your understanding):
-----To achieve this, you can use the following metrics and explore a few yourself as well. 
-----Availability within 15,30,45,etc. days, Acceptance Rate, Average no of bookings, reviews, etc.     


select * from dallas_listings;


select property_type, avg(price)/ avg(accommodates) price_per_accomodate
from dallas_listings group by property_type order by price_per_accomodate desc;


with cte1 as (
select listing_id, count(date) available_days
from dallas_availability where available like 'true'  group by listing_id )

select available_days, count(listing_id) num_of_listings from cte1 where available_days>=300
group by available_days order by available_days desc;


select  month(date) month_num ,datename(month, date) month_of_availability, count(listing_id) count_of_listings_available  
from dallas_availability where available like 'true'  group by datename(month, date), month(date) order by month_num

select 
case when instant_bookable= 0 then 'not_instant_bookable'
else 'instant_bookable' end as booking_type,
count(id) num_of_listings 
from dallas_listings


with cte1 as (
select case when instant_bookable= 0 then 'not_instant_bookable'
else 'instant_bookable' end as booking_type, id from dallas_listings)

select booking_type, count(id) num_of_listings from cte1 group by booking_type order by count(id) desc;


select datename(weekday, date) days_of_the_week , count(id) num_of_available_listings
from dallas_availability where available = 'true'
group by datename(weekday, date) order by num_of_available_listings desc;

select * from
(select datename(weekday, date) days_of_the_week , id, year(date) year_
from dallas_availability where available = 'true')a
pivot( count(id) for year_ in ([2022],[2023])) as years_


select distinct(year(date)) from dallas_availability


select * from dallas_listings;
select * from dallas_hosts;
select * from dallas_review;
select * from dallas_availability;


select h.host_id, count(l.id) number_of_listings , h.host_response_time, h.host_response_rate
from dallas_listings l join dallas_hosts h on l.host_id=h.host_id 
group by h.host_id, h.host_response_time, h.host_response_rate order by number_of_listings desc;


select * from dallas_availability where listing_id = 48563007 order by date;




select 
from dallas_hosts h join dallas_review r 


select r.listing_id , r.comments from dallas_hosts h join dallas_listings l 
on 
r  where comments like 


select host_id from dallas_hosts where host_is_superhost=1;




select h.host_id,h.host_name, avg(l.review_scores_rating) rating , count(l.id) count_ 
from dallas_hosts h inner join dallas_listings l on h.host_id = l.host_id where h.host_is_superhost = 1 
group by h.host_id, h.host_name order by count_ desc;


select h.host_id,h.host_name, avg(l.review_scores_rating) rating , count(l.id) count_ 
from dallas_hosts h inner join dallas_listings l on h.host_id = l.host_id where h.host_is_superhost = 0
group by h.host_id, h.host_name order by count_ desc;

select * from (select h.host_id,h.host_name, avg(l.review_scores_rating) rating , count(l.id) count_ 
from dallas_hosts h inner join dallas_listings l on h.host_id = l.host_id where h.host_is_superhost = 0
group by h.host_id, h.host_name)a where rating = 5 order by rating desc;



select l.neighbourhood_cleansed, count(h.host_id) count_of_superhost
from dallas_hosts h inner join dallas_listings l on h.host_id = l.host_id where h.host_is_superhost = 1
group by l.neighbourhood_cleansed order by count_of_superhost desc;


select l.neighbourhood_cleansed, count(h.host_id) count_of_non_superhost
from dallas_hosts h inner join dallas_listings l on h.host_id = l.host_id where h.host_is_superhost = 0
group by l.neighbourhood_cleansed order by count_of_non_superhost desc;


with cte1 as (
select l.neighbourhood_cleansed, count(h.host_id) count_of_superhost
from dallas_hosts h inner join dallas_listings l on h.host_id = l.host_id where h.host_is_superhost = 1
group by l.neighbourhood_cleansed ),

cte2 as(
select l.neighbourhood_cleansed, count(h.host_id) count_of_non_superhost
from dallas_hosts h inner join dallas_listings l on h.host_id = l.host_id where h.host_is_superhost = 0
group by l.neighbourhood_cleansed )

select cte1.*, cte2.count_of_non_superhost
from cte1 inner join cte2 on cte1.neighbourhood_cleansed = cte2.neighbourhood_cleansed order by cte1.count_of_superhost desc;





select * from dallas_listings;
select * from dallas_hosts;
select * from dallas_review;
select * from dallas_availability;

with cte1 as(
select l.property_type , count(r.comments) number_of_good_comments
from dallas_listings l inner join dallas_review r on l.id = r.listing_id
where r.comments like '%good%' or r.comments like '%great%' or r.comments like '%awesome%' or r.comments like '%love%' or 
r.comments = '%easy%'or r.comments = '%wonderful%' or r.comments = '%comfortable%' or r.comments = '%recommended%' 
group by l.property_type ),

 cte2 as (

select l.property_type , count(r.comments) number_of_bad_comments
from dallas_listings l inner join dallas_review r on l.id = r.listing_id
where r.comments like '%not%' or r.comments like '%bad%' or r.comments like '%worst%' or r.comments like '%uncomfortable%' or 
 r.comments = '%issue%' 
group by l.property_type ),

cte3 as (
select cte1.*, cte2.number_of_bad_comments, number_of_bad_comments+ number_of_good_comments total_number_of_comments

from cte1 inner join cte2 on cte1.property_type = cte2.property_type)

select  property_type, number_of_good_comments*100/total_number_of_comments Percent_of_good_comments, 
number_of_bad_comments*100/total_number_of_comments percent_of_bad_comments
from cte3 order by Percent_of_good_comments desc;


select 55/11





with cte1 as(
select l.property_type , count(r.comments) number_of_good_comments
from dallas_listings l inner join dallas_review r on l.id = r.listing_id
where r.comments like '%good%' or r.comments like '%great%' or r.comments like '%awesome%' or r.comments like '%love%' or 
r.comments = '%easy%'or r.comments = '%wonderful%' or r.comments = '%comfortable%' or r.comments = '%recommended%' 
group by l.property_type order by number_of_good_comments)

 cte2 as (

select l.property_type , count(r.comments) number_of_bad_comments
from dallas_listings l inner join dallas_review r on l.id = r.listing_id
where r.comments like '%not%' or r.comments like '%bad%' or r.comments like '%worst%' or r.comments like '%uncomfortable%' or 
 r.comments = '%issue%' 
group by l.property_type order by number_of_bad_comments desc)

select cte1.*, cte2.number_of_bad_comments
from cte1 inner join cte2 on cte1.property_type = cte2.property_type;



select * from dallas_hosts;
with cte1 as(

select host_neighbourhood , count(host_id) number_of_nonsuperhosts 
from dallas_hosts where host_is_superhost = 0 group by host_neighbourhood order by number_of_nonsuperhosts desc


select host_neighbourhood , count(host_id) number_of_superhosts 
from dallas_hosts where host_is_superhost = 1 group by host_neighbourhood order by number_of_superhosts desc



select * from dallas_listings;
select * from dallas_hosts;
select * from dallas_review;
select * from dallas_availability;

with cte1 as (
select  month(date) month_num ,datename(month, date) month_of_availability, count(listing_id) count_of_listings_available  
from dallas_availability where available like 'true'  group by datename(month, date), month(date) order by month_num)

select property_type, count(a.id) over (partition by property_type) number_of_available_listings, month(a.date) month_
from dallas_listings l inner join dallas_availability a on l.id = a.listing_id where a.available like 'true'
group by property_type, month(a.date) order by month(a.date)

select * from(
select month(a.date) as months_, l.property_type, datename(month,a.date) month_,count(a.id) as available_listing,
DENSE_RANK() over(partition by l.property_type order by count(a.id) desc) rank_
from dallas_listings l left join dallas_availability a on l.id = a.listing_id
where a.available like 'true'
group by month(a.date), l.property_type, datename(month,a.date)
) a
where rank_ = 1
order by months_;

 


 select * from(
select month(a.date) as months_, l.property_type, datename(month,a.date) month_,count(a.id) as available_listing,
DENSE_RANK() over(partition by l.property_type order by count(a.id) desc) rank_
from listing_austin l left join df_austin_availability a on l.id = a.listing_id
where a.available like 'true'
group by month(a.date), l.property_type, datename(month,a.date)
) a
where rank_ = 1
order by months_;



select top 10 h.host_id,h.host_name, avg(l.review_scores_rating) rating , count(l.id) count_ 
from host_austin h inner join listing_austin l on h.host_id = l.host_id group by h.host_id, h.host_name order by count_ desc;


select property_type, avg(price)/ avg(accommodates) price_per_accomodate
from listing_austin group by property_type order by price_per_accomodate desc;

select property_type, avg(price) Average_price, avg(price)/avg(accommodates) Price_per_accommodate
from listingD
group by property_type;



select  month(date) month_num ,datename(month, date) month_of_availability, count(listing_id) count_of_listings_available  
from df_austin_availability where available like 'true'  group by datename(month, date), month(date) order by month_num


with cte1 as (select case when instant_bookable= 0 then 'not_instant_bookable'
else 'instant_bookable' end as booking_type, id from listing_austin)
select booking_type, count(id) num_of_listings from cte1 group by booking_type order by count(id) desc;


select datename(weekday, date) days_of_the_week , count(id) num_of_available_listings
from df_austin_availability where available = 'true'
group by datename(weekday, date) order by num_of_available_listings desc;

select * from listing_austin;
select * from aus




select property_type, avg(price) as average_price
from listing_austin
where instant_bookable like 'true'
group by property_type
having avg(review_scores_rating) >= 4.5
                and avg(review_scores_accuracy) >= 4.5
                        and avg(review_scores_checkin) >= 4.5
                                and avg(review_scores_cleanliness) >= 4.5
                                        and avg(review_scores_accuracy) >= 4.5
                                                and avg(review_scores_communication) >= 4.5
                                                        and avg(review_scores_location) >= 4.5
                                                                and avg(review_scores_value) >= 4.5
order by average_price;





select * from listing_austin;





with cte1 as(
select l.property_type , count(r.comments) number_of_good_comments
from listing_austin l inner join review_ausin r on l.id = r.listing_id
where r.comments like '%good%' or r.comments like '%great%' or r.comments like '%awesome%' or 
r.comments like '%love%' or 
r.comments = '%easy%'or r.comments = '%wonderful%' or r.comments = '%comfortable%' or r.comments = '%recommended%' 
group by l.property_type),

 cte2 as (
select l.property_type , count(r.comments) number_of_bad_comments
from listing_austin l inner join review_austin r on l.id = r.listing_id
where r.comments like '%not%' or r.comments like '%bad%' or 
r.comments like '%worst%' or r.comments like '%uncomfortable%' or r.comments = '%issue%' 
group by l.property_type),

cte3 as (
select cte1.*, cte2.number_of_bad_comments, number_of_bad_comments+ number_of_good_comments total_number_of_comments
from cte1 inner join cte2 on cte1.property_type = cte2.property_type)

select  property_type, number_of_good_comments*100/total_number_of_comments Percent_of_good_comments, 
number_of_bad_comments*100/total_number_of_comments percent_of_bad_comments
from cte3 order by Percent_of_good_comments desc;




with cte1 as(
select l.property_type , count(r.comments) number_of_good_comments
from listing_austin l inner join review_austin r on l.id = r.listing_id
where r.comments like '%good%' or r.comments like '%great%' or r.comments like '%awesome%' or 
r.comments like '%love%' or 
r.comments = '%easy%'or r.comments = '%wonderful%' or r.comments = '%comfortable%' or r.comments = '%recommended%' 
group by l.property_type),

 cte2 as (
select l.property_type , count(r.comments) number_of_bad_comments
from listing_austin l inner join review_austin r on l.id = r.listing_id
where r.comments like '%not%' or r.comments like '%bad%' or 
r.comments like '%worst%' or r.comments like '%uncomfortable%' or r.comments = '%issue%' 
group by l.property_type),

cte3 as (
select cte1.*, cte2.number_of_bad_comments, number_of_bad_comments+ number_of_good_comments total_number_of_comments
from cte1 inner join cte2 on cte1.property_type = cte2.property_type)



select property_type, count(id) instant_bookables
from listing_austin
where instant_bookable = 'True'
group by property_type
order by instant_bookables desc;

select * from review_austin;
select * from host_austin;
select * from df_austin_availability;


with cte1 as(
select l.property_type , count(r.comments) number_of_good_comments
from listing_austin	 l inner join review_austin r on l.id = r.listing_id
where r.comments like '%good%' or r.comments like '%great%' or r.comments like '%awesome%' or r.comments like '%love%' or 
r.comments = '%easy%'or r.comments = '%wonderful%' or r.comments = '%comfortable%' or r.comments = '%recommended%' 
group by l.property_type ),

 cte2 as (

select l.property_type , count(r.comments) number_of_bad_comments
from listing_austin l inner join review_austin r on l.id = r.listing_id
where r.comments like '%not%' or r.comments like '%bad%' or r.comments like '%worst%' or r.comments like '%uncomfortable%' or 
 r.comments = '%issue%' 
group by l.property_type ),

cte3 as (
select cte1.*, cte2.number_of_bad_comments, number_of_bad_comments+ number_of_good_comments total_number_of_comments

from cte1 inner join cte2 on cte1.property_type = cte2.property_type)


Select l.property_type,avg( h.host_acceptance_rate) host_acceptance_rate
 from  listing_austin l join host_austin h on l.host_id = h.host_id
 Group by l.property_type
 Order by host_acceptance_rate desc;
