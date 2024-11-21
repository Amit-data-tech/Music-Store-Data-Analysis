/* Q1: Who is the senior most employee based on job title? */

select top 1 first_name, last_name, title, hire_date
from employee
order by hire_date;

/* Q2: Which countries have the most Invoices? */

select billing_country, count(*) as count_of_invoice
from invoice
group by billing_country
order by count_of_invoice desc;

/* Q3: What are top 3 values of total invoice? */

select top 3 total
from invoice
order by total desc;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select top 1 billing_city, sum(total) as total
from invoice
group by billing_city
order by total desc;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select top 1 c.customer_id,c.first_name,c.last_name,sum(i.total) as total
from customer as c
left join invoice as i
on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name
order by total desc;

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct c.email,c.first_name,c.last_name,g.name as genre
from customer as c
left join invoice as i
on c.customer_id=i.customer_id
left join invoice_line as il
on i.invoice_id=il.invoice_id
left join track as t
on il.track_id=t.track_id
left join genre as g
on t.genre_id=g.genre_id
where g.name = 'Rock';

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select top 10 ar.name,count(al.album_id) as count_of_album
from album as al
left join artist as ar
on ar.artist_id=al.artist_id
left join track as t
on t.album_id=al.album_id
left join genre as g
on t.genre_id=g.genre_id
where g.name = 'Rock'
group by ar.name
order by count_of_album desc;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name,milliseconds
from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc;

/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent */

select c.first_name,c.last_name,ar.name,sum(i.total) as total_amount
from customer as c
left join invoice as i
on c.customer_id=i.customer_id
left join invoice_line as il
on i.invoice_id=il.invoice_id
left join track as t
on il.track_id=t.track_id
left join album as al
on t.album_id=al.album_id
left join artist as ar
on ar.artist_id=al.artist_id
group by c.first_name,c.last_name,ar.name
order by c.first_name,c.last_name,ar.name;


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

with cte as (
select i.billing_country as Country, g.name as genre, max(i.total) as Total_Amount,
ROW_NUMBER()over(partition by i.billing_country order by i.billing_country,max(i.total) desc) as rownumber
from invoice as i
left join invoice_line as il
on i.invoice_id=il.invoice_id
left join track as t
on il.track_id=t.track_id
left join genre as g
on t.genre_id=g.genre_id
group by i.billing_country,g.name
)
select country, genre, Total_Amount 
from cte
where rownumber = 1;

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */


with cte as(select c.first_name+' '+c.last_name as Name,c.country,i.total,
rank()over(partition by c.country order by i.total desc) as rank_no
from customer as c
left join invoice as i
on c.customer_id=i.customer_id)
select Name,country,total
from cte
where rank_no =1; 