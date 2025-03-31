# Purpose of this Repository
This repository is a tutorial and code reference for loading data into Snowflake using internal and external stages. It provides step-by-step guidance and examples to help you efficiently upload data to Snowflake's internal and external staging for further processing and analysis. In this example, we are using a simple pokedex CSV file.

## Prerequisites
Before you begin, ensure you have the following:
1. Access to a Snowflake account.
2. SnowSQL CLI installed (for internal staging).
3. AWS Account (for external staging).

SnowSQL is a command-line tool that helps connect to Snowflake and run queries from your local machine.
[Use this link to download SnowSQL](https://www.snowflake.com/en/developers/downloads/snowsql/)

## Repository Structure
- **`internal_staging.md`**
  - STEP 1: Creating a Database & Schema (Optional)
  - STEP 2: Creating File Format
  - STEP 3: Creating the Pokémon Table
  - STEP 4: Create Internal Named Stage (Optional)
  - STEP 5: Uploading the File to the Stage
  - STEP 6: Copying Data from the File to the Table
  - STEP 7: Remove Files to Avoid Storage Costs

- **`external_staging.md`**
  - STEP 1: Creating a Database & Schema (Optional)
  - STEP 2: Creating File Format
  - STEP 3: Creating the Pokémon Table
  - STEP 4: Create AWS S3 Bucket
  - STEP 5: Creating an IAM Role
  - STEP 6: Creating Storage Integration
  - STEP 7: Editing Role Trust Policy
  - STEP 8: Create External Stage
  - STEP 9: Copy Data into the Pokémon Table

- **`pokedex.csv`**
  - A sample dataset containing Pokémon information for staging and loading into Snowflake.
