CREATE OR REPLACE DATABASE POKEDEX;
CREATE SCHEMA FILE_FORMATS;
CREATE SCHEMA EXTERNAL_STAGING;

USE SCHEMA FILE_FORMATS;

CREATE OR REPLACE FILE FORMAT CSV_DATA
TYPE = 'CSV'
FIELD_DELIMITER = ','
COMPRESSION = 'AUTO'
SKIP_HEADER = 1
TRIM_SPACE = TRUE;

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

-- To connect Snowflake with S3 we need a role with permissions. 
-- I suggest creating a new role. Go to IAM > Create New Role
-- Trusted entity type -> AWS Account
-- An AWS account -> Select the option Require external ID (Best practice when a third party will assume this role)
--  Set Required external ID as  00000. We will update this later.
-- Press next and in the next screen give appropriate permissions. For tutorial purposes, you can just select 'AmazonS3FullAccess'
-- Press next, give a role name and create the role. 

CREATE OR REPLACE STORAGE INTEGRATION S3_INTEGRATION
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  -- ARN of the role we created above.
  STORAGE_AWS_ROLE_ARN = '<- An AWS ANR role with appropriate S3 permissions ->'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('S3://< - Your S3 Bucket ->')
  COMMENT = 'Storage integration for S3 pokemon bucket';

-- Storage_AWS_EXTERNAL_ID --> sts:ExternalId & STORAGE_AWS_IAM_USER_ARN --> AWS 
-- Update the Trust policy of the ARN role with the values from the following command.
DESC INTEGRATION S3_INTEGRATION;


-- Creating an external stage
CREATE OR REPLACE STAGE POKEDEX.EXTERNAL_STAGING.external_s3_stage
URL = 's3://< - Your S3 Bucket ->/'
STORAGE_INTEGRATION = S3_INTEGRATION
FILE_FORMAT = POKEDEX.FILE_FORMATS.CSV_DATA;

-- This should list down csv in the bucket. 
LIST @external_s3_stage;

-- Check for errors
COPY INTO POKEDEX.PUBLIC.POKEMON
FROM @POKEDEX.EXTERNAL_STAGING.EXTERNAL_S3_STAGE/pokedex.csv
FILE_FORMAT = POKEDEX.FILE_FORMATS.CSV_DATA
VALIDATION_MODE = 'RETURN_ERRORS';

-- Simple copy into command
COPY INTO POKEDEX.PUBLIC.POKEMON
FROM @POKEDEX.EXTERNAL_STAGING.EXTERNAL_S3_STAGE/pokedex.csv
FILE_FORMAT = POKEDEX.FILE_FORMATS.CSV_DATA;


SELECT * FROM POKEDEX.PUBLIC.POKEMON;
