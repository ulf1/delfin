USE `testdb`;
DROP FUNCTION IF EXISTS `irr_newton`;

DELIMITER $$
CREATE FUNCTION `irr_newton`(
    maxiter SMALLINT(5) UNSIGNED, 
    toleps DOUBLE
) RETURNS DOUBLE DETERMINISTIC
BEGIN
    -- Internal Rate of Return (IRR) by applying the 
    --      Newton-Raphson Method as root-finding algorithm
    -- 
    -- Parameters:
    --      maxiter     Maximum number of iterations (Default: 50)
    --      toleps      What is considered Zero for the Min Target Function (Default: 1e-5)
    -- 
    -- Temporary Table:
    --      DROP TEMPORARY TABLE IF EXISTS __tmp_tbl_irrcashflows__ ;
    --      CREATE TEMPORARY TABLE __tmp_tbl_irrcashflows__ (d DOUBLE, v DOUBLE);
    --      INSERT INTO __tmp_tbl_irrcashflows__(d,v) VALUES (..., ...), ...;
    -- 
    -- Returns:
    --      irr         The Internal Rate of Returns
    -- 
    
    -- declare intermediate variables    
    DECLARE i SMALLINT(5) UNSIGNED;
    DECLARE x DOUBLE;  -- the variable x_k (IRR)
    DECLARE f DOUBLE;  -- target function f(x_k) -> 0
    DECLARE fa DOUBLE; -- derivative f' of f
    
    -- error settings    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION RETURN NULL;

    -- remove Zero cashflows
    DELETE FROM __tmp_tbl_irrcashflows__ WHERE v=0e0 OR ISNULL(v) OR ISNULL(d);
    
    -- Check 1/2: All cashflows are negative
    IF (SELECT SUM(v<0e0)=COUNT(*) FROM __tmp_tbl_irrcashflows__) THEN
        RETURN -1e0;
    END IF;
    
    -- Check 2/2: All cashflows are positive
    IF (SELECT SUM(v>0e0)=COUNT(*) FROM __tmp_tbl_irrcashflows__) THEN
        RETURN 1.7976931348623157E+308;
    END IF;
    
    -- Default Args 1/2
    IF ISNULL(maxiter) THEN
        SET maxiter := 50;
    END IF;
    
    -- Default Args 2/2
    IF ISNULL(toleps) OR (toleps <= 0e0) THEN
        SET toleps := 1e-5;
    END IF;

    -- start values
    SET x := 0;
    SET f := (SELECT SUM( v * EXP(-x * d) ) FROM __tmp_tbl_irrcashflows__);
    SET fa := (SELECT SUM( v * (-d) * EXP(-x * d) ) FROM __tmp_tbl_irrcashflows__);

    -- Newton–Raphson Method
    SET i := 0;    
    WHILE (i < maxiter) AND (ABS(f) >= toleps) AND (ABS(fa) >= 1e-8) DO
        -- get the next x
        SET x := x - (f / fa); 
        -- compute target function (present value of cashflows)
        SET f := (SELECT SUM( v * EXP(-x * d) ) FROM __tmp_tbl_irrcashflows__);        
        -- compute derivative
        SET fa := (SELECT SUM( v * (-d) * EXP(-x * d) ) FROM __tmp_tbl_irrcashflows__);
        -- increment counter
        SET i := i + 1;
    END WHILE;
    
    -- no solution found
    IF (i >= maxiter) THEN
        RETURN NULL;
    END IF;    
    -- convert to percentage
    SET x := EXP(x) - 1.0;
    -- done
    IF (x>-1e0) THEN
        RETURN x;
    ELSE
        RETURN NULL;
    END IF;    
END
$$ DELIMITER ;