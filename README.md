* How to create a project.
- go to the directory.
- run {cabal init}. 
- It create a cabal project.

- For build  {cabal build}
- For build + run {cabal run}


- with above chage I am able to run helloWorld. :)

- Now lets start with, how we can do the db connection?
- For mysql we require mysql-haskell package. That we need add in build-dependency.
- {cabal update} to download the new package.

* Lets create a new use for over project.
- CREATE USER 'helloWorld'@'localhost' IDENTIFIED BY 'scape';
- GRANT ALL PRIVILEGES ON *.* TO 'helloWorld'@'localhost';
- FLUSH PRIVILEGES;
- quit

- mysql -u helloWorld -pscape;
- ALTER USER 'helloWorld'@'localhost' IDENTIFIED WITH mysql_native_password by 'scape;
- If you face authentication error for mysql connectivity : https://medium.com/@kelvinekrresa/mysql-client-does-not-support-authentication-protocol-6eed9a6e813e

- 



CREATE TABLE IF NOT EXISTS example_table (id TEXT PRIMARY KEY, value INTEGER)
INSERT INTO example_table (id, value) VALUES ('row1', 1);
INSERT INTO example_table (id, value) VALUES ('row2', 2);