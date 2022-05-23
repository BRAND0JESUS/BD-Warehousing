
--a 
CREATE TABLE erp.tb_quarter (
  quarter INTEGER NOT NULL,
  year INTEGER NOT NULL,
  cust_no CHAR(5) NOT NULL,
  iva_percent INTEGER NOT NULL,
  amount REAL NOT NULL,
  PRIMARY KEY (quarter, year),
  FOREIGN KEY (cust_no) REFERENCES erp.tb_customer(cust_no));

--b 
CREATE OR REPLACE FUNCTION erp.fn_update_lines() RETURNS trigger
AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.net_amount <> OLD.net_amount OR NEW.iva_amount <> OLD.iva_amount THEN
      UPDATE erp.tb_invoice SET net_amount = (SELECT SUM(net_amount) FROM erp.tb_lines WHERE invoice_id = NEW.invoice_id) + NEW.net_net_amount;
      UPDATE erp.tb_invoice SET iva_amount = (SELECT SUM(iva_amount) FROM erp.tb_lines WHERE invoice_id = NEW.invoice_id) + NEW.iva_amount;
      UPDATE erp.tb_invoice SET tot_amount = (SELECT SUM(net_amount) FROM erp.tb_lines WHERE invoice_id = NEW.invoice_id) + (SELECT SUM(NEW.iva_amount) FROM erp.tb_lines WHERE invoice_id = NEW.invoice_id) + NEW.net_net_amount + NEW.iva_amount;
      END IF;
  IF TG_OP = 'INSERT' THEN
    UPDATE erp.tb_invoice SET net_amount = (SELECT SUM(net_amount) FROM erp.tb_lines WHERE invoice_id = NEW.invoice_id) + NEW.net_amount;
    UPDATE erp.tb_invoice SET iva_amount = (SELECT SUM(iva_amount) FROM erp.tb_lines WHERE invoice_id = NEW.invoice_id) + NEW.iva_amount; 
    UPDATE erp.tb_invoice SET tot_amount = (SELECT SUM(net_amount) FROM erp.tb_lines WHERE invoice_id = NEW.invoice_id) + (SELECT SUM(NEW.iva_amount) FROM erp.tb_lines WHERE invoice_id = NEW.invoice_id) + NEW.net_amount + NEW.iva_amount;
    END IF;
  END IF;
  
  IF TG_OP = 'DELETE' THEN
    UPDATE erp.tb_invoice SET net_amount = (SELECT SUM(net_amount) FROM erp.tb_lines WHERE invoice_id = OLD.invoice_id) - OLD.net_amount;
    UPDATE erp.tb_invoice SET iva_amount = (SELECT SUM(iva_amount) FROM erp.tb_lines WHERE invoice_id = OLD.invoice_id) - OLD.iva_amount;
    UPDATE erp.tb_invoice SET tot_amount = (SELECT SUM(net_amount) FROM erp.tb_lines WHERE invoice_id = OLD.invoice_id) + (SELECT SUM(iva_amount) FROM erp.tb_lines WHERE invoice_id = OLD.invoice_id) - OLD.net_amount - OLD.iva_amount;
    END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_lines
BEFORE INSERT OR UPDATE OR DELETE ON erp.tb_lines FOR EACH
ROW EXECUTE PROCEDURE erp.fn_update_lines();

/*UPDATE erp.tb_lines SET net_amount = 100, iva_amount = 20 WHERE invoice_id = 201 AND line_id = 4;

DELETE FROM erp.tb_lines WHERE invoice_id = 201;

INSERT INTO erp.tb_lines (INVOICE_ID,LINE_ID,LINE_NUM,ITEM,DESCRIPTION,NET_AMOUNT,IVA_AMOUNT,LAST_UPDATED_BY,LAST_UPDATE_DATE)
VALUES (201,9999,5,null,'Varios',20,4.9,'SYSTEM',current_date);*/


