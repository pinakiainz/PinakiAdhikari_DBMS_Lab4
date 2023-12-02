# Q9) Create a stored procedure to display supplier id, name, rating and Type_of_supplier. 
# If rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”. 
#======================================================================================================
# Identify the tables[order,supplier_pricing,supplier,rating]
# Lets start with rating table
select * from rating;
#======================================================================================================
#from result it is clear that rating is provided with specif order_id of order table so lets apply join with order table on rating table
select * from `order` as o
inner join 
rating as rat
on o.ORD_ID = rat.ORD_ID;
#======================================================================================================
# Refine the result and only take relevant colunms
select o.PRICING_ID, rat.ORD_ID , rat.RAT_RATSTARS from `order` as o
inner join 
rating as rat
on o.ORD_ID = rat.ORD_ID;

#======================================================================================================
# We can now join above result with supplier_pricing table
select * from supplier_pricing as sp
inner join
(
	select o.PRICING_ID, rat.ORD_ID , rat.RAT_RATSTARS from `order` as o
	inner join 
	rating as rat on o.ORD_ID = rat.ORD_ID
) as t1 on sp.PRICING_ID =t1.pricing_id;

#======================================================================================================
# Only take relevant columns
select * from supplier_pricing as sp
inner join
(
	select o.PRICING_ID, rat.ORD_ID , rat.RAT_RATSTARS from `order` as o
	inner join 
	rating as rat on o.ORD_ID = rat.ORD_ID
) as t1 on sp.PRICING_ID =t1.pricing_id;
#======================================================================================================
# Only take releveant colunmns
select sp.SUPP_ID,t1.ord_id,t1.rat_ratstars from supplier_pricing as sp
inner join
(
	select o.PRICING_ID, rat.ORD_ID , rat.RAT_RATSTARS from `order` as o
	inner join 
	rating as rat on o.ORD_ID = rat.ORD_ID
) as t1 on sp.PRICING_ID =t1.pricing_id;
#======================================================================================================
# Sort by column supp_id we can found various rating for each supplier so find avarage

select test2.supp_id, avg(rat_ratstars) as Average from
(
	select sp.SUPP_ID,t1.ord_id,t1.rat_ratstars from supplier_pricing as sp
	inner join
	(
		select o.PRICING_ID, rat.ORD_ID , rat.RAT_RATSTARS from `order` as o
		inner join 
		rating as rat on o.ORD_ID = rat.ORD_ID
	) as t1 on sp.PRICING_ID =t1.pricing_id
) as test2 group by test2.SUPP_ID;
#==========================================================================================================================
# Apply Case
select final.supp_id, supplier.supp_name, final.Average from
(
	select test2.supp_id, sum(test2.rat_ratstars)/count(test2.rat_ratstars) as Average from
	(
		select supplier_pricing.supp_id, test.ORD_ID, test.RAT_RATSTARS from supplier_pricing 
        inner join
		(
			select `order`.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS from `order` 
            inner join 
            rating on rating.`ord_id` = `order`.ord_id 
		) as test on test.pricing_id = supplier_pricing.pricing_id
	) as test2 group by supplier_pricing.supp_id
) as final inner join supplier where final.supp_id = supplier.supp_id ;

#=================================================================================
# Apply Case
select  report.SUPP_ID, report.Average,
CASE
	WHEN report.Average =5 THEN 'Excellent Service'
	WHEN report.Average >4 THEN 'Good Service'
	WHEN report.Average >2 THEN 'Average Service'
	ELSE 'Poor Service'
END AS Type_of_Service from
 (
	select test2.supp_id, avg(rat_ratstars) as Average from
	(
		select sp.SUPP_ID,t1.ord_id,t1.rat_ratstars from supplier_pricing as sp
		inner join
		(
			select o.PRICING_ID, rat.ORD_ID , rat.RAT_RATSTARS from `order` as o
			inner join 
			rating as rat on o.ORD_ID = rat.ORD_ID
		) as t1 on sp.PRICING_ID =t1.pricing_id
	) as test2 group by test2.SUPP_ID
) as report;

# Apply procedure
DELIMITER $$
USE `a_ecommerce`$$
CREATE PROCEDURE `supplier_ratings` ()
BEGIN
	select report.SUPP_ID, report.Average,
CASE
	WHEN report.Average =5 THEN 'Excellent Service'
	WHEN report.Average >4 THEN 'Good Service'
	WHEN report.Average >2 THEN 'Average Service'
	ELSE 'Poor Service'
END AS Type_of_Service from
 (
	select test2.supp_id, avg(rat_ratstars) as Average from
	(
		select sp.SUPP_ID,t1.ord_id,t1.rat_ratstars from supplier_pricing as sp
		inner join
		(
			select o.PRICING_ID, rat.ORD_ID , rat.RAT_RATSTARS from `order` as o
			inner join 
			rating as rat on o.ORD_ID = rat.ORD_ID
		) as t1 on sp.PRICING_ID =t1.pricing_id
	) as test2 group by test2.SUPP_ID
) as report;
END$$

DELIMITER ;