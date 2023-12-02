# Q7) Display the Id and Name of the Product ordered after “2021-10-05”.
# Identify the tables[order,supplier_pricing,product]
#=======================================================================================================
# Lets start from order table, 
select * from `order`;
# Now join it with supplier_pricing

SELECT * FROM `ORDER` AS O
inner join 
supplier_pricing as sp on sp.PRICING_ID=o.pricing_id;
# Lets take only those order which is  ordered after “2021-10-05”
SELECT o.*, sp.PRO_ID FROM `ORDER` AS O
inner join 
supplier_pricing as sp on sp.PRICING_ID=o.pricing_id and O.ord_date>"2021-10-05";



# Lets take relevent colunm only
select * from product as p
inner join 
(
	SELECT o.*, sp.PRO_ID FROM `ORDER` AS O
	inner join 
	supplier_pricing as sp on sp.PRICING_ID=o.pricing_id
) as q 
on p.PRO_ID = q.PRO_ID;

select p.PRO_ID,p.PRO_NAME from product as p
inner join 
(
	SELECT o.*, sp.PRO_ID FROM `ORDER` AS O
	inner join 
	supplier_pricing as sp on sp.PRICING_ID=o.pricing_id and O.ord_date>"2021-10-05"
) as q 
on p.PRO_ID = q.PRO_ID;