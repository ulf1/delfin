-- 
-- CTRL+F to replace "newuser" and "secretpassword"
-- 

-- delete the user if necessary
DROP USER 'newuser'@'%';
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User = 'newuser';

-- create the new user
GRANT ALL PRIVILEGES ON *.* TO 'newuser'@'%' IDENTIFIED BY 'secretpassword';

-- Replace "mydb1", "mydb2", "mydb3", etc. depending on your DB setup
GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE, SHOW VIEW, CREATE TEMPORARY TABLES, DROP ON mydb1.* TO 'newuser'@'%';
GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE, SHOW VIEW ON mydb2.* TO 'newuser'@'%';
GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE, SHOW VIEW, CREATE TEMPORARY TABLES, DROP ON mydb3.* TO 'newuser'@'%';

-- Make changes effective
FLUSH PRIVILEGES;
