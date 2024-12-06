# Purpose of this Repository
This repository is a tutorial and code reference for loading data into Snowflake using internal and external stages. It provides step-by-step guidance and examples to help you efficiently upload data to Snowflake's internal and external staging for further processing and analysis. In this example, we are using a simple pokedex CSV file. 

## Prerequisites
Before you begin, ensure you have the following:
1. Access to a Snowflake account
2. SnowSQL CLI installed (for internal staging)
3. AWS Account (for external staging)

snowSQL is a command line tool which helps connect to Snowflake and run queries from your local machine. 
[Use this link to download snowSQL](https://www.snowflake.com/en/developers/downloads/snowsql/)

## Repository Structure
- internal_staging.md
  - [STEP 1: CREATING A DATABASE & A SCHEMA (OPTIONAL)](https://github.com/Ballal65/Snowflake-csv-upload-with-internal-and-external-staging/blob/main/internal_staging.md#step-1-creating-a-database--a-schema-optional)
  - [STEP 2: CREATING FILE FORMAT](https://github.com/Ballal65/Snowflake-csv-upload-with-internal-and-external-staging/blob/main/internal_staging.md#step-2-creating-file-format)
  - [STEP 3: CREATING THE POKEMON TABLE](Ehttps://github.com/Ballal65/Snowflake-csv-upload-with-internal-and-external-staging/blob/main/internal_staging.md#step-3-creating-the-pokemon-table)
  - [STEP 4: CREATE INTERNAL NAMED STAGE (OPTIONAL)](https://github.com/Ballal65/Snowflake-csv-upload-with-internal-and-external-staging/blob/main/internal_staging.md#step-4-create-internal-named-stage-optional)
