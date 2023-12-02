# Q5) Display the Supplier details of who is supplying more than three product.
#==========================================================================================================
# Identify tables [supplier, supplier_pricing]
SELECT * FROM supplier AS SUP;
SELECT  * FROM supplier_pricing AS SP;


# Select Only those ids who have count more than 1;
SELECT SP.SUPP_ID FROM supplier_pricing AS SP GROUP BY SP.SUPP_ID HAVING COUNT(SP.SUPP_ID)>3;

# Select supplier details from supplier only whose id is present in above query
SELECT SUP.* FROM supplier AS SUP WHERE SUP.SUPP_ID IN
(
	SELECT SP.SUPP_ID FROM supplier_pricing AS SP GROUP BY SP.SUPP_ID HAVING COUNT(SP.SUPP_ID)>3
) ;