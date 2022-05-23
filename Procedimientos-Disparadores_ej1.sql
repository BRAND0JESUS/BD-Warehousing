-- a) y b)

-- funcion que permiya actualizar los datos de un cliente siempre que no 
-- se intente modificar el campo last_update_date

CREATE OR REPLACE FUNCTION erp.fn_update_customer()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.last_update_date IS DISTINCT FROM OLD.last_update_date THEN
        RAISE EXCEPTION 'No se puede modificar el campo last_update_date';
	END IF;
    IF NEW.last_updated_by IS DISTINCT FROM OLD.last_updated_by THEN
        RAISE EXCEPTION 'No se puede modificar el campo last_updated_by';
    END IF;
    -- si no se modifica ninguno de los campos mencionados, se actualiza la fecha de actualizacion
      NEW.last_updated_by = current_user;
	  NEW.last_update_date = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- crear trigger que ejecute la funcion anterior
CREATE TRIGGER tr_update_customer
-- antes de actualizar se debe hacer el analisis
BEFORE UPDATE ON erp.tb_customer
FOR EACH ROW EXECUTE PROCEDURE erp.fn_update_customer();

/*UPDATE erp.tb_customer
SET cust_name = 'ANGEL GUAMAN', cust_cif = 'J00112255', last_updated_by = 'USUARIO', last_update_date = '2000-05-05' 
WHERE cust_no = 'C0017';
SELECT * FROM erp.tb_customer;*/


-- c)
-- similar al anterior, pero con una funcion que permite actualizar los datos de la factuaras, siempe que se haga
-- algun cambio en la tb_lines

CREATE OR REPLACE FUNCTION erp.fn_update_lines()
RETURNS TRIGGER AS $$
DECLARE
    -- variables para almacenar los datos de la factura
        v_invoice_id INT;
        v_line_id INT;
        v_line_num INT;
        v_item CHAR(5);
        v_description VARCHAR(120);
        v_net_amount REAL;
        v_iva_amount REAL;
        v_last_updated_by VARCHAR(20);
        v_last_update_date DATE;
BEGIN
        -- si se ha eliminado un registro de la tb_lines
    IF (TG_OP = 'DELETE') THEN
        -- 
        v_invoice_id := OLD.invoice_id;
        v_line_id := OLD.line_id;
        v_net_amount := OLD.net_amount;
        v_iva_amount := OLD.iva_amount;
        -- eliminar el registro de la tb_lines
        DELETE FROM erp.tb_lines
          WHERE invoice_id = v_invoice_id
            AND line_id = v_line_id
            AND line_num = v_line_num;
        -- actualimos la tabla tb_invoice
        UPDATE erp.tb_invoice
          SET net_amount = net_amount - v_net_amount,
              iva_amount = iva_amount - v_iva_amount,
              tot_amount = tot_amount - v_net_amount - v_iva_amount
          WHERE invoice_id = v_invoice_id;
        RETURN OLD;
      -- si se ha insertado un registro de la tb_lines
      ELSEIF (TG_OP = 'INSERT') THEN
        v_invoice_id := NEW.invoice_id;
        v_line_id := NEW.line_id;
        v_line_num := NEW.line_num;
        v_item := NEW.item;
        v_description := NEW.description;
        v_net_amount := NEW.net_amount;
        v_iva_amount := NEW.iva_amount;
        v_last_updated_by := NEW.last_updated_by;
        v_last_update_date := NEW.last_update_date;
        -- actualizar la tb_invoice
      UPDATE erp.tb_invoice
        SET net_amount = net_amount + v_net_amount,
            iva_amount = iva_amount + v_iva_amount,
            tot_amount = tot_amount + v_net_amount + v_iva_amount
        WHERE invoice_id = v_invoice_id;
      RETURN NEW;
      
      -- si se ha actualizado un registro de la tb_lines
      ELSE
        v_net_amount := NEW.net_amount;
        v_iva_amount := NEW.iva_amount;
      UPDATE erp.tb_invoice
        SET net_amount = net_amount - OLD.net_amount + v_net_amount,
            iva_amount = iva_amount - OLD.iva_amount + v_iva_amount,
            tot_amount = tot_amount + v_net_amount + v_iva_amount - OLD.net_amount - OLD.iva_amount
        WHERE invoice_id = v_invoice_id;
      RETURN NEW;
      END IF;
     
END;
$$ language 'plpgsql';

-- crear trigger que ejecute la funcion anterior
CREATE TRIGGER tr_update_lines
AFTER INSERT OR UPDATE OR DELETE ON erp.tb_lines
FOR EACH ROW EXECUTE PROCEDURE erp.fn_update_lines();

/*
DELETE FROM erp.tb_lines WHERE invoice_id = 201 AND line_id = 2622;

INSERT INTO erp.tb_lines (INVOICE_ID,LINE_ID,LINE_NUM,ITEM,DESCRIPTION,NET_AMOUNT,IVA_AMOUNT,LAST_UPDATED_BY,LAST_UPDATE_DATE)
VALUES (201,9900,10,null,'Ejemplo',1000,1000,'USUARIO',current_date);
INSERT INTO erp.tb_lines (INVOICE_ID,LINE_ID,LINE_NUM,ITEM,DESCRIPTION,NET_AMOUNT,IVA_AMOUNT,LAST_UPDATED_BY,LAST_UPDATE_DATE)
VALUES (201,9901,11,null,'Ejemplo',1000,1000,'USUARIO',current_date);

UPDATE erp.tb_lines SET net_amount = 500 WHERE invoice_id = 201 AND line_id = 900;
SELECT * FROM erp.tb_invoice WHERE invoice_id = 201;*/
