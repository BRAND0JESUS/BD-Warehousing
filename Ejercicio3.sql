
-- A)

INSERT INTO erp.tb_site
(cust_no, site_id, site_code, site_name, site_address, site_city, site_country, site_phone, co_code, last_update_date)
VALUES
('C0007', 27, 'S1202', 'ALMACEN VIGO', 'Camiño das Relfas, 120', 'Vigo', 'Espa�a', NULL, 'AB1', current_date),
('C0007', 28, 'S1203', 'OFICINA MALLORCA', 'Carrer del Romaní, 1', 'Mallorca', 'Espa�a', NULL, 'BB5', current_date),
('C0001', 29, 'S0103', 'ALMACEN GRENOBLE', 'Rue Augereau, 2', 'Grenoble', 'Francia', 31123311231, 'XX6', current_date);
-- ver los resultados de la opreción anterior
-- SELECT *
-- FROM erp.tb_site
-- ORDER BY site_id DESC
-- LIMIT 5;


-- B)

ALTER TABLE erp.tb_site
ADD CONSTRAINT site_country_check
CHECK (site_country = 'Espa�a' OR (site_country <> 'Espa�a' AND site_phone IS NOT NULL));
-- Aplicación de la restricción
/*ERROR*/
--INSERT INTO erp.tb_site (cust_no, site_id, site_code, site_name, site_address, site_city, site_country, site_phone, co_code, last_updated_by, last_update_date) 
--VALUES ('C0011',30,'S0011','SUCURSAL NORTE','Av. Julio Dunis, 1','Lisboa','Portugal', NULL,'BB5','SYSTEM',current_date);
/*CORRECTO*/
INSERT INTO erp.tb_site (cust_no, site_id, site_code, site_name, site_address, site_city, site_country, site_phone, co_code, last_updated_by, last_update_date) 
VALUES ('C0011',30,'S0011','SUCURSAL NORTE','Av. Julio Dunis, 1','Lisboa','Portugal', 987456322,'BB5','SYSTEM',current_date);
-- Visualizar la tabla tb_site
-- SELECT *
-- FROM erp.tb_site
-- ORDER BY site_id DESC
-- LIMIT 5;

-- C)

CREATE OR REPLACE VIEW erp.v_imp_pendiente AS
SELECT inv.co_code, comp.co_name, inv.cust_no, cust.cust_name, inv.iva_amount, inv.tot_amount
FROM erp.tb_invoice inv, erp.tb_customer cust, erp.tb_company comp
WHERE inv.co_code = comp.co_code
AND inv.cust_no = cust.cust_no
AND inv.payed = 'N'
ORDER BY comp.co_name ASC, inv.cust_no DESC
-- WITH LOCAL CHECK OPTION;

-- ver view anterior
-- SELECT *
-- FROM erp.v_imp_pendiente
-- ORDER BY co_name ASC, cust_no DESC
-- LIMIT 5;



-- D)
ALTER TABLE erp.tb_site
ADD COLUMN active_date DATE NOT NULL DEFAULT current_date;

-- Visualización de la tabla tb_site y de la nueva columna
-- SELECT * 
-- FROM erp.tb_site
-- ORDER BY site_id DESC
-- LIMIT 5;


-- E)

CREATE USER registerer WITH LOGIN PASSWORD '1234';
GRANT USAGE ON SCHEMA erp TO registerer;
GRANT ALL ON erp.tb_iva TO registerer;
GRANT SELECT ON erp.tb_company TO registerer;

