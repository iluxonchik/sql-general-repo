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


# Exercise 2

#a
SELECT DISTINCT customer_name
FROM customer
WHERE NOT EXISTS (SELECT customer_name
                    FROM borrower
                    WHERE borrower.customer_name = customer.customer_name);

#b
-- Using ','
SELECT customer.customer_name, avg(balance) as avg_balance
FROM customer, depositor, account, branch
WHERE customer.customer_name = depositor.customer_name AND
      depositor.account_number = account.account_number AND
      account.branch_name = branch.branch_name AND
      branch.branch_city = "Brooklyn"
GROUP BY customer.customer_name;

-- Using 'NATURAL JOIN'
SELECT customer_name, avg(balance) as avg_balance
FROM customer NATURAL JOIN depositor NATURAL JOIN account NATURAL JOIN branch
WHERE branch_city = "Brooklyn"
GROUP BY customer_name;

#c
SELECT count(customer_name) as num_customers
FROM customer NATURAL JOIN depositor NATURAL JOIN account NATURAL JOIN branch
WHERE branch_city = customer_city;

#d
SELECT sum(balance) as total
FROM branch NATURAL JOIN account
WHERE branch_city = "Brooklyn";

#e
CREATE TEMPORARY TABLE IF NOT EXISTS joined
    SELECT DISTINCT *
    FROM depositor NATURAL JOIN borrower NATURAL  JOIN loan;

SELECT count(DISTINCT customer_name) as num_clients
FROM customer
WHERE EXISTS (SELECT customer_name
              FROM joined
              WHERE joined.customer_name = customer.customer_name);

#f
CREATE TEMPORARY TABLE IF NOT EXISTS loan_sum
SELECT customer_name, sum(amount) as amount
FROM loan NATURAL JOIN borrower NATURAL JOIN customer
GROUP BY customer_name;

CREATE TEMPORARY TABLE IF NOT EXISTS max_loan
SELECT max(amount) as max
FROM loan_sum;

SELECT customer_name, customer_street, customer_city
FROM loan_sum NATURAL JOIN customer, max_loan
WHERE amount = max;

-- Using HAVING
SELECT customer_name, customer_street, customer_city
FROM customer NATURAL JOIN borrower NATURAL JOIN loan
GROUP BY customer_name
HAVING sum(amount) >= ALL (SELECT sum(amount)
                           FROM loan NATURAL JOIN borrower
                           GROUP BY customer_name);

#g

SELECT customer_name, customer_street, customer_city
FROM customer NATURAL JOIN depositor NATURAL JOIN account
GROUP BY customer_name
HAVING sum(balance) >= ALL (SELECT sum(balance)
                            FROM depositor NATURAL JOIN account
                            GROUP BY customer_name);

-- Using TEMPORART TABLE
CREATE TEMPORARY TABLE IF NOT EXISTS balance_sum
SELECT sum(balance) as total_balance
FROM depositor NATURAL JOIN account
GROUP BY customer_name;

SELECT customer_name, customer_street, customer_city
FROM customer NATURAL JOIN depositor NATURAL JOIN account
GROUP BY customer_name
HAVING sum(balance) >= ALL (SELECT max(total_balance)
                            FROM balance_sum);

#h
SELECT branch_name
FROM account
GROUP BY branch_name
HAVING count(account_number) >= ALL (SELECT count(account_number)
                                   FROM account
                                   GROUP BY branch_name);

#i
SELECT customer_name
FROM account a1 NATURAL JOIN depositor
WHERE EXISTS (
        SELECT branch_name
        FROM branch
        WHERE branch_name NOT IN (
            SELECT branch_name
            FROM account a2
            WHERE a1.account_number = a2.account_number
            )
        );

#j
SELECT customer.customer_name
FROM customer, borrower
WHERE customer.customer_name = borrower.customer_name
GROUP BY customer_name
HAVING count(borrower.loan_number) > 2
ORDER BY customer.customer_name;

#k
SELECT count(DISTINCT customer.customer_name) as num_clients
FROM branch, account, depositor, customer, borrower, loan
WHERE branch.branch_name = account.branch_name AND
      account.account_number = depositor.account_number AND
      depositor.customer_name = customer.customer_name AND
      customer.customer_name = borrower.customer_name AND
      borrower.loan_number = loan.loan_number AND
      branch.branch_city = 'Brooklyn' AND
      loan.branch_name IN (SELECT branch.branch_name
              FROM branch, loan
                            WHERE branch.branch_name = loan.branch_name AND
                            branch.branch_city = 'Brooklyn');

#l
SELECT branch.branch_city
FROM branch, account, depositor, customer
WHERE branch.branch_name = account.branch_name AND
      account.account_number = depositor.account_number AND
      depositor.customer_name = customer.customer_name
GROUP BY branch.branch_city
HAVING count(customer.customer_name) >= ALL (SELECT count(customer.customer_name) /* number of customers per city */
                                            FROM branch, account, depositor, customer
                                            WHERE branch.branch_name = account.branch_name AND
                                                  account.account_number = depositor.account_number AND
                                                  depositor.customer_name = customer.customer_name
                                            GROUP BY branch.branch_city);
