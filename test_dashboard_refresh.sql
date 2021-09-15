-- create duplicate of vehicle sales data
CREATE TABLE cleaned_sales_data_dup AS
SELECT
  *
FROM
  cleaned_sales_data;

-- delete rows where sales > 3000 (this will delete 1541 rows)
DELETE FROM
  cleaned_sales_data
WHERE
  sales > 3000;

-- check that the `Sales Dashboard` refreshes with new data

-- insert back the deleted rows and check that it refreshes back to the original dashboard
INSERT INTO
  cleaned_sales_data
SELECT
  *
FROM
  cleaned_sales_data_dup
WHERE
  sales > 3000;
