# Q6) Find the least expensive product from each category and print the table with category id, name, and price of the product
#=====================================================================================================================================
#Identfiy the tables[supplier_pricing,product,category]
select * from product;
select * from supplier_pricing;
select * from category;

# Start with supplier_pricing
select * from supplier_pricing;
# Sort the records on PRO_ID, we can observer that each product have  prices by different suppliers.alter
# So we have to identify that product which have min price.
select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id;

# Now Join above resuet with product table
select * from product as p
inner join
(
	select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id
) as t2 on t2.PRO_ID=p.PRO_ID;

# Refine the result and take only necessary columns
select p.CAT_ID, p.PRO_NAME, t2.* from product as p
inner join
(
	select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id
) as t2 on t2.PRO_ID=p.PRO_ID;
#=====================================================================================================================================
# Join above result with category
select * from category as cat
inner join 
(
	select p.CAT_ID, p.PRO_NAME, t2.* from product as p
	inner join
	(
		select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id
	) as t2 on t2.PRO_ID=p.PRO_ID
) as t3 on t3.CAT_ID= cat.CAT_ID;

# Refine the result
select c.CAT_ID,c.CAT_NAME, min(t3.min_price) as Min_Price from category as c
inner join 
(
	select p.CAT_ID, p.PRO_NAME, t2.* from product as p
	inner join
	(
		select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id
	) as t2 on t2.PRO_ID=p.PRO_ID
) as t3 on t3.CAT_ID= c.CAT_ID group by t3.CAT_ID;





select category.cat_id,category.cat_name, min(t3.min_price) as Min_Price from category 
inner join
(
	select product.cat_id, product.pro_name, t2.* from product 
    inner join
	(
		select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id
	) as t2 where t2.pro_id = product.pro_id
) as t3 where t3.cat_id = category.cat_id group by t3.cat_id;