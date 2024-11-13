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
### STEP 4: DOWNLOAD AND INSTALL snowSQL (if you haven't already)
snowSQL is a command line tool which helps connect to Snowflake and run queries from your local machine. 
[Use this link](https://www.snowflake.com/en/developers/downloads/snowsql/)

### STEP 5: UPLOADING THE FILE TO SNOWFLAKE INTERNAL STAGE
Snowflake has 3 types of internal stages. 
1. Table Stage: Every table has a dedicated table stage. You need to be an owner or have appropriate privileges to use this. Files added to this stage can be only used for the table.
2. User Stage: Every user of the account gets a dedicated user stage. Files in the user stage can be accessed by the user alone.
3. Named internal stage: Files stored in this stage can be accessed by multiple users.

Reference symbols: 
- Table Stage: @<namespace>.%<table_name>
- User Stage: @<namespace>.@~;
- Named Stage: @<stage_name>

**Now, let's back to coding**

Open your terminal to log in to snowsql. To log in you will need your username and account URL. You can get these credentials by logging into your Snowflake account. 


```
snowsql -a .ap-southeast-1 -u balliboy
```




