## Uploading pokedex.csv to Internal Stages

### STEP 1: CREATING A DATABASE & A SCHEMA (OPTIONAL)
```
CREATE OR REPLACE DATABASE POKEDEX;
CREATE SCHEMA FILE_FORMATS;
CREATE SCHEMA INTERNAL_STAGING;
```
### STEP 2: CREATING FILE FORMAT
```
USE SCHEMA FILE_FORMATS;

CREATE OR REPLACE FILE FORMAT CSV_DATA
TYPE = 'CSV'
FIELD_DELIMITER = ','
COMPRESSION = 'AUTO'
SKIP_HEADER = 1,
TRIM_SPACE = TRUE;
```

We can do `DESC FILE FORMAT CSV_DATA;` to get some info about the file format we just created. 

### STEP 3: CREATING THE POKEMON TABLE
```
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE POKEDEX.PUBLIC.POKEMON(
    "Image" STRING,
    "INDEX" INTEGER PRIMARY KEY,
    "Name" STRING,
    "Type 1" STRING,
    "Type 2" STRING,
    "Total" INTEGER,
    "HP" INTEGER,
    "Attack" INTEGER,
    "Defense" INTEGER,
    "SP. Atk." INTEGER,
    "SP. Def" INTEGER,
    "Speed" INTEGER
);
```

### STEP 4: CREATE INTERNAL NAMED STAGE (OPTIONAL): 
```
CREATE OR REPLACE STAGE POKEDEX.INTERNAL_STAGING.NAMED_STAGE
FILE_FORMAT = POKEDEX.FILE_FORMATS.CSV_DATA
COMMENT = 'THIS IS A NAMED STAGE SHARED BETWEEN ACCOUNTS';
```

### STEP 5: UPLOADING THE FILE TO THE STAGE
Snowflake has 3 types of internal stages. 
1. Table Stage: Every table has a dedicated table stage. You need to be an owner or have appropriate privileges to use this. Files added to this stage can be only used for the table.
2. User Stage: Every user of the account gets a dedicated user stage. Files in the user stage can be accessed by the user alone.
3. Named internal stage: Files stored in this stage can be accessed by multiple users.

Reference symbols: 
- Table Stage: @<namespace>.%<table_name>
- User Stage: @<namespace>.@~;
- Named Stage: @<stage_name>


You can just open your terminal to log in to snowsql. To log in you will need your username and account URL. You can get these credentials by logging into your Snowflake account. 
![Account](https://github.com/Ballal65/Snowflake-csv-upload-with-internal-and-external-staging/raw/main/screenshot.png)
Your account URL looks something like
```
https://<identifier>.<region>.snowflakecomputing.com/
```
#### SnowSQL Login
In your local machine, you can use the copied credentials to log in. -a flag is used for account identifier and -u flag is used for username.
```
snowsql -a <identifier>.<region> -u <username>
```
After login, you will see this. 

```
> snowsql -a <identifier>.<region> -u <username>
Password:
* SnowSQL * v1.3.1
Type SQL statements or !help
USERNAME#COMPUTE_WH@(no database).(no schema)>
```
Select database and schema. 
```
USE DATABASE POKEDEX;
USE SCHEMA INTERVAL_STAGING;
```
The PUT command is used to copy files from the local machine to the Snowflake internal stages. 

To PUT pokedex.csv file in the user stage
```
PUT 'file://your_file_address/pokedex.csv' @~;
```

To PUT pokedex.csv file in the table stage 
```
PUT 'file://your_file_address/pokedex.csv' @POKEDEX.PUBLIC.%POKEMON;
```

To PUT pokedex.csv file in NAMED_STAGE created in step 4.
```
PUT 'file://E:/github projects/pokemon/csv/pokedex.csv' @POKEDEX.INTERVAL_STAGING.NAMED_STAGE;
```

**WOW! We just uploaded a file to Snowflake. Now Let's upload the CSV data to the Pokemon folder.**
To check the files in the stages
```
LIST @POKEDEX.PUBLIC.%POKEMON; -- Table Stage
LIST @~; -- User Stage
LIST @POKEDEX.INTERNAL_STAGING.NAMED_STAGE; -- Internal Named stage
```

### STEP 6: COPYING DATA FROM THE FILE TO THE TABLE
To copy data from the stage, we need a simple copy into the command. Just uncomment the stage that you want to copy to and execute the following command. 
```
COPY INTO POKEDEX.PUBLIC.POKEMON
-- FROM @~/pokedex.csv.gz  -- User Stage
-- FROM @POKEMON.PUBLIC.%POKEMONS  -- Table Stage
-- FROM @POKEMON.INTERNAL_STAGING.NAMED_STAGE -- Internal Named Storage
FILE_FORMAT = POKEDEX.FILE_FORMATS.CSV_DATA;
```

We have successfully loaded the Pokemon table. To check this, you can run
```
SELECT * FROM POKEDEX.PUBLIC.POKEMON;
```

### STEP 7: REMOVE FILES TO AVOID STORAGE COST
```
-- Deleting the file to avoid additional charges
REMOVE @~/pokedex.csv.gz;  -- User Stage
REMOVE @POKEMON.PUBLIC.%POKEMONS; -- Table Stage
REMOVE @POKEMON.INTERNAL_STAGING.NAMED_STAGE;
```
