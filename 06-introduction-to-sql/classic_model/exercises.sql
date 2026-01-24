-- This is a comment, it won't be processed
/*

To question the database we use a SELECT statment, which has this form:

	1. SELECT - **only mandatory clause** in the select statement; list of columns
	2. FROM - list of tables from where we want to extract information
	3. WHERE - condition(s) that we want to enforce over the rows
	4. GROUP BY - list of columns names; grouping variables
	5. HAVING - condition that we apply to aggregate functions (count, sum, avg, etc)
	6. ORDER BY - list of columns names utilised to sort the final result
	7. LIMIT - N; how to extract the top-N
*/

-- 0. Show all columns and rows from the table offices
-- * == all columns


-- 1. Show all rows from the table offices, but only the officecode, country, state and city columns

-- 2. Same as before, but renaming the names of the columns

-- 3. Sames as before, but sorted by country, state, city.
-- * == all columns

-- 4. List all information of the offices from the country USA

-- 5. How many employees are there in the company?
-- count() is an aggregator fucntion

-- 6. What is the total of payments received?

-- sum() is an aggregator function

-- 7. Show the total of payments received by each customer

-- 8. What is the total of payments done by customer with the number 103

-- 9. List the product lines that contain 'Cars'.

-- 10. Report total payments for October 28, 2004.

-- 11. Report those payments greater than $100,000

-- 12. Report the top-3 most expensive payments

-- 13. Report all payments including the customername

-- 14. Report the top-3 most expensive payments including the customername, contactfirstname, and contactlastname

-- 15. CROSS-JOIN = all possible pairs of (employees, offices)

-- 16. How many products exist in each product line?

-- 	 16.1 What if there are no products in a certain product line?

--  16.2 We need to use a LEFT JOIN to preserve all columns in the LEFT (productlines)

-- 17. What is the minimum payment received?

-- 18. List all payments greater than twice the average payment.

-- 19. What is the average percentage markup of the MSRP on buyPrice?
-- The percentage is calculate with 100 * (msrp - buyprice) / msrp

-- 20. List the distinct vendor of products?




-- EXTRA QUERIES/ Exercises

-- 13. Report the name and city of customers who don't have sales representatives?
-- 14. What are the names of executives with VP or Manager in their title?
-- 15. Which orders have a value greater than $5,000?
-- 16. Report the account representative for each customer.
-- 17. Report total payments for Atelier graphique.
-- 18. Report the total payments by date
-- 19. Report the products that have not been sold.
-- 20. List the amount paid by each customer.
-- 21. How many orders have been placed by Herkku Gifts?
-- 22. Who are the employees in Boston?
-- 23. Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.
-- 24. List the value of 'On Hold' orders.
-- 25. Report the number of orders 'On Hold' for each customer.
-- 26. List products sold by order date.
-- 27. List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
-- 28. List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?
-- 29. Are there any products that appear on all orders?
-- 30. List the names of products sold at less than 80% of the MSRP.
-- 31. Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
-- 32. List the products ordered on a Monday.
-- 33. What is the quantity on hand for products listed on 'On Hold' orders?
-- 34. Find products containing the name 'Ford'.
-- 35. List products ending in 'ship'.
-- 36. Report the number of customers in Denmark, Norway, and Sweden.
-- 37. What are the products with a product code in the range S700_1000 to S700_1499?
-- 38. Which customers have a digit in their name?
-- 39. List the names of employees called Dianne or Diane.
-- 40. List the products containing ship or boat in their product name.
-- 41. List the products with a product code beginning with S700.
-- 42. List the names of employees called Larry or Barry
-- 43. List the names of employees with non-alphabetic characters in their names.
-- 44. List the vendors whose name ends in Diecast.
-- 45. Who is at the top of the organization (i.e.,  reports to no one).
-- 46. Who reports to William Patterson?
-- 47. List all the products purchased by Herkku Gifts.
-- 48. Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. Sort by employee last name and first name.
-- 49. What is the difference in days between the most recent and oldest order date in the Orders file?
-- 50. Compute the average time between order date and ship date for each customer ordered by the largest difference.
-- 51. What is the value of orders shipped in August 2004?
-- 52. Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 and payments received in 2004.
-- 53. List the employees who report to those employees who report to Diane Murphy. Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
-- 54. What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first).
-- 55. Write a function to convert miles per gallon to liters per 100 kilometer56. Write a procedure to increase the price of a specified product category by a given percentage. You will need to create a product table with appropriate data to test your procedure. Alternatively, load the ClassicModels database on your personal machine so you have complete access. You have to change the DELIMITER prior to creating the procedure.
-- 57. What is the value of orders shipped in August 2004? (Hint).
-- 58. What is the ratio the value of payments made to orders received for each month of 2004. (i.e., divide the value of payments made by the orders received)?
-- 59. What is the difference in the amount received for each month of 2004 compared to 2003?
-- 60. Write a procedure to report the amount ordered in a specific month and year for customers containing a specified character string in their name.
-- 61. Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.
-- 62. Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn what products are often purchased together. Report the names of products that appear in the same order ten or more times.
-- 63. ABC reporting: Compute the revenue generated by each customer based on their orders. Also, show each customer's revenue as a percentage of total revenue. Sort by customer name.
-- 64. Compute the profit generated by each customer based on their orders. Also, show each customer's profit as a percentage of total profit. Sort by profit descending.
-- 65. Compute the revenue generated by each sales representative based on the orders from the customers they serve.
-- 66. Compute the profit generated by each sales representative based on the orders from the customers they serve. Sort by profit generated descending.
-- 67. Compute the revenue generated by each product, sorted by product name.
-- 68. Compute the profit generated by each product line, sorted by profit descending.
-- 69. Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.
-- 70. Compute the ratio of payments for each customer for 2003 versus 2004.
-- 71. Find the products sold in 2003 but not 2004.
-- 72. Find the customers without payments in 2003.
-- 73. Who reports to Mary Patterson?
-- 74. Which payments in any month and year are more than twice the average for that month and year (i.e. compare all payments in Oct 2004 with the average payment for Oct 2004)? Order the results by the date of the payment.
-- 75. Report for each product, the percentage value of its stock on hand as a percentage of the stock on hand for product line to which it belongs. Order the report by product line and percentage value within product line descending. Show percentages with two decimal places.
-- 76. For orders containing more than two products, report those products that constitute more than 50% of the value of the order.
-- 77. List the employees name (first and lastname) and the name of his/her manager (first and last name)
