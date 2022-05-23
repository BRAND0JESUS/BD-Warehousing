
-- a_1)
SELECT comp.co_name, SUM(inv.tot_amount) AS total,
CASE 
WHEN SUM(inv.tot_amount) >= 1.5E+6 THEN 'Gasto elevado'
WHEN SUM(inv.tot_amount) > 7.5E+5 THEN 'Gasto moderado'
ELSE 'Gasto bajo'
END
FROM erp.tb_invoice inv, erp.tb_company comp
WHERE inv.co_code = comp.co_code
GROUP BY comp.co_name
ORDER BY total DESC;


-- a_2)
UPDATE erp.tb_lines
SET item = COALESCE (item, 'NA')
WHERE item IS NULL;

SELECT *
FROM erp.tb_lines
WHERE item = 'NA';

-- Ejemplo si queremos deteminar el costo sin incluir el iva, si no existiera valor de IVA.
-- SELECT cust.cust_name, lin.description, lin.net_amount, lin.iva_amount,
-- lin.net_amount - COALESCE (lin.iva_amount, 0) AS net_amount_sin_iva
-- FROM erp.tb_invoice inv, erp.tb_customer cust, erp.tb_lines lin
-- WHERE inv.cust_no = cust.cust_no
-- AND inv.invoice_id = lin.invoice_id;


--a_3)
SELECT cust.cust_name, lin.description, lin.net_amount,
NULLIF (lin.description, 'Varios') AS description
FROM erp.tb_invoice inv, erp.tb_customer cust, erp.tb_lines lin
WHERE inv.cust_no = cust.cust_no
AND inv.invoice_id = lin.invoice_id;

--b)

INSERT INTO erp.tb_customer  (cust_no, cust_name, cust_cif, last_update_date)
VALUES ('C0020','UOC EXAMPLE','A87654321', current_date)
RETURNING *;
