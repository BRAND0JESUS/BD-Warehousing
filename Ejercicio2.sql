
-- A)

SELECT cust_no, cust_name, cust_cif
FROM erp.tb_customer
WHERE cust_name LIKE 'AGR%'
ORDER BY cust_no DESC;


-- B)

SELECT inv.cust_no, cust.cust_name, sit.site_address, sit.site_city, inv.invoice_no
FROM erp.tb_invoice inv, erp.tb_customer cust, erp.tb_site sit
WHERE sit.site_city = 'Granada'
AND inv.cust_no = cust.cust_no
AND inv.site_id = sit.site_id
ORDER BY inv.cust_no ASC, inv.invoice_no DESC;


-- C)

SELECT comp.co_code, comp.co_name, COUNT(inv.invoice_no)
FROM erp.tb_company comp, erp.tb_invoice inv
WHERE inv.co_code = comp.co_code
GROUP BY comp.co_code
ORDER BY comp.co_name;

-- D)

SELECT inv.invoice_no, cust.cust_name, comp.co_name, COUNT(lin.line_id)     -- COUNT(*) > 18
FROM erp.tb_invoice inv, erp.tb_customer cust, erp.tb_lines lin, erp.tb_company comp
WHERE lin.invoice_id = inv.invoice_id
AND inv.co_code = comp.co_code
AND inv.cust_no = cust.cust_no
GROUP BY inv.invoice_no, cust.cust_name, comp.co_name
HAVING COUNT(lin.line_id) > 18      -- COUNT() > 18
ORDER BY COUNT(lin.line_id) DESC, comp.co_name;


-- E)

SELECT inv.co_code, comp.co_name, inv.cust_no, cust.cust_name, inv.iva_amount, inv.tot_amount
FROM erp.tb_invoice inv, erp.tb_customer cust, erp.tb_company comp
WHERE inv.co_code = comp.co_code
AND inv.cust_no = cust.cust_no
AND inv.payed = 'N'
ORDER BY comp.co_name ASC, inv.cust_no DESC;

