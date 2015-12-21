# Triggers and Stored Procedures Exercises

# 1

#a
DROP FUNCTION abs_balance;
DELIMITER //
CREATE FUNCTION abs_balance(client_name VARCHAR(20))
RETURNS DECIMAL(20, 2)
BEGIN
    DECLARE tot_balance DECIMAL(20, 2);
    DECLARE tot_loan DECIMAL(20, 2);

    SELECT SUM(account.balance) INTO tot_balance
    FROM customer, depositor, account
    WHERE customer.customer_name = client_name AND
          customer.customer_name = depositor.customer_name AND
          account.account_number = depositor.account_number
    GROUP BY customer.customer_name;

    IF tot_balance IS NULL THEN
        SET tot_balance = 0;
    END IF;

    SELECT SUM(loan.amount) INTO tot_loan
    FROM customer, borrower, loan
    WHERE customer.customer_name = client_name AND
          customer.customer_name = borrower.customer_name AND
          borrower.loan_number = loan.loan_number
    GROUP BY customer.customer_name;

    IF tot_loan IS NULL THEN
        SET tot_loan = 0;
    END IF;

    RETURN tot_balance - tot_loan;
END //
DELIMITER ;

#b
DELIMITER //
CREATE FUNCTION balance_diff(agency1 VARCHAR(255), agency2 VARCHAR(255))
RETURNS DECIMAL(20, 2)
BEGIN
    DECLARE balance_avg_a1 DECIMAL(20, 2);
    DECLARE balance_avg_a2 DECIMAL(20, 2);

    SELECT AVG(account.balance) INTO balance_avg_a1
    FROM account, branch
    WHERE branch.branch_name = agency1 AND
          branch.branch_name = account.branch_name
    GROUP BY branch.branch_name;

    IF balance_avg_a1 IS NULL THEN
        SET balance_avg_a1 = 0;
    END IF;

    SELECT AVG(account.balance) INTO balance_avg_a2
    FROM account, branch
    WHERE branch.branch_name = agency2 AND
          branch.branch_name = account.branch_name
    GROUP BY branch.branch_name;


    IF balance_avg_a2 IS NULL THEN
        SET balance_avg_a2 = 0;
    END IF;

    RETURN balance_avg_a1 - balance_avg_a2;
END //
DELIMITER ;

#c
# IDEA: cross product to associate branch with every other branch (and itself), then select the
# branch whose minimum balance difference is zero (resulting from subtration from itself)
# Example of resulting table:
#
#   b1  b2  balance_diff(b1, b2)
#   A   A   0
#   A   B   -10
#   A   C   20
#   A   D   250
#  ... ...
#
SELECT b1.branch_name
FROM branch b1, branch b2
GROUP BY b1.branch_name
HAVING MIN(balance_diff(b1.branch_name, b2.branch_name)) = 0;