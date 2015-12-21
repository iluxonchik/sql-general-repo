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
