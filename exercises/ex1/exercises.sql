# Exercise 1

#a
-- USING NATURAL JOIN
SELECT customer_name
FROM customer NATURAL JOIN depositor NATURAL JOIN account
WHERE balance > 500;

-- Using INNER JOIN
SELECT depositor.customer_name
FROM customer INNER JOIN depositor ON customer.customer_name = depositor.customer_name 
INNER JOIN account ON depositor.account_number = account.account_number
WHERE balance > 500;

-- Using ","
SELECT c.customer_name
FROM customer c, depositor d, account a
WHERE c.customer_name = d.customer_name AND d.account_number = a.account_number
AND a.balance > 500;

#b
SELECT customer_city
FROM customer NATURAL JOIN borrower NATURAL JOIN loan
WHERE amount > 1000 and amount < 2000;

#c
SELECT customer_name, balance * 1.1
FROM customer NATURAL JOIN depositor NATURAL JOIN account
WHERE branch_name = "Downtown";

#d
SELECT account_number, balance
FROM borrower NATURAL JOIN customer NATURAL JOIN depositor NATURAL JOIN account
WHERE loan_number = "L-15";

SELECT sum(balance) AS total_balance
FROM borrower NATURAL JOIN customer NATURAL JOIN depositor NATURAL JOIN account
WHERE loan_number = "L-15";

#e
SELECT DISTINCT customer.customer_name
FROM customer INNER JOIN branch ON customer.customer_city = branch.branch_city;

SELECT DISTINCT customer_name
FROM customer, branch
WHERE customer.customer_city = branch.branch_city;

#f
SELECT assets
FROM customer NATURAL JOIN depositor NATURAL JOIN account NATURAL JOIN branch
WHERE customer_name = "Jones";

#g
SELECT branch.branch_name
FROM customer, depositor, account, branch
WHERE customer.customer_name = depositor.customer_name 
AND depositor.account_number = account.account_number
AND account.branch_name = branch.branch_name
AND customer.customer_name LIKE "J%s";

#h
SELECT customer_name, amount
FROM loan NATURAL JOIN borrower NATURAL JOIN customer
WHERE customer_street LIKE "____";

#i
SELECT customer_name
FROM customer NATURAL JOIN borrower NATURAL JOIN loan NATURAL JOIN branch
WHERE customer.customer_city = branch.branch_city;