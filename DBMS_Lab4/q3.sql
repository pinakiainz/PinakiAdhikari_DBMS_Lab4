# Q3) Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
 # Identfiy the tables. [order,customer]
 select * from `order` ;
 select * from customer;
 # Apply join between these two tables.alter
SELECT * FROM `order` AS o
INNER JOIN customer AS c
ON c.CUS_ID=o.CUS_ID;

# Refine the result
SELECT o.*  FROM `order` AS o
INNER JOIN customer AS c
ON c.CUS_ID=o.CUS_ID ;
# Lets take relevant column only
SELECT o.* , c.CUS_NAME,c.CUS_GENDER FROM `order` AS o
INNER JOIN customer AS c
ON c.CUS_ID=o.CUS_ID HAVING o.ORD_AMOUNT>=3000;
#________________________________________________________________________________________________________________
SELECT COUNT(T2.CUS_GENDER) AS No_Of_Customer,T2.CUS_GENDER AS Gender FROM 
(
	SELECT T1.CUS_ID,T1.CUS_GENDER,T1.ORD_AMOUNT,T1.CUS_NAME FROM 
	(
		SELECT o.* , c.CUS_NAME,c.CUS_GENDER FROM `order` AS o
		INNER JOIN customer AS c
		ON c.CUS_ID=o.CUS_ID HAVING o.ORD_AMOUNT>=3000
	) AS T1 
) AS T2 GROUP BY T2.CUS_GENDER;


