# Purpose of this Repository
This repository is a tutorial and code reference for loading data into Snowflake using internal and external stages. It provides step-by-step guidance and examples to help you efficiently upload data to Snowflake's internal/external staging  for further processing and analysis. In this example, we are using a simple pokedex CSV file. 

## What is Staging? 
Snowflake staging refers to temporarily storing data in a staging area within Snowflake before loading it into a table or after unloading it from a table. If we store data inside the Snowflake, we call it 'Internal Staging' If data is stored in AWS, Azure or GSP, we call it 'External Staging'. 


## Internal Staging
### STEP 1: CREATING A DATABASE & A SCHEMA (OPTIONAL)
```
CREATE OR REPLACE DATABASE POKEDEX;
CREATE SCHEMA FILE_FORMATS;
CREATE SCHEMA EXTERNAL_STAGING;
CREATE SCHEMA INTERVAL_STAGING;

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


