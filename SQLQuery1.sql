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