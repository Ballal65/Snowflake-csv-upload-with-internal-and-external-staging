## Uploading pokedex.csv to Internal Stages

### STEP 1: CREATING A DATABASE & A SCHEMA (OPTIONAL)
```
CREATE OR REPLACE DATABASE POKEDEX;
CREATE SCHEMA FILE_FORMATS;
CREATE SCHEMA EXTERNAL_STAGING;
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
### STEP 4: CREATE AWS S3 BUCKET
- FROM AWS Console go to S3
- Click on the "Create bucket" option.
- I am naming it `pokemon-csv-data`
- Keep default options and create the bucket. 
- upload pokedex.csv file to the bucket.
- Go to the bucket -> properties
- Copy the Amazon Resource Name (ARN) and paste it somewhere locally. We will use this later.
  
### STEP 5: CREATING AN IAM USER
- From AWS Console go to IAM.
- The left sidebar shows the roles option. Go to roles. Click the "CREATE ROLE" button.
- Choose options like the image below. We will change the external ID later.
- Give S3FullAccess to the role.
- I am naming it `Snowflake-s3-stoage-integtation`
- Once the role is created, click on the role from the set of roles and copy ARN. Save this ARN somewhere locally. We will use it later.

![IAM CREATE USE SCREENSHOT](https://github.com/Ballal65/Snowflake-csv-upload-with-internal-and-external-staging/blob/main/iam_aws_screenshot.png)

### STEP 6: CREATING STORAGE INTEGRATION
We will use the CREATE STORAGE INTEGRATION command like this. 
```
CREATE OR REPLACE STORAGE INTEGRATION <name>
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDED = S3
STORAGE_AWS_ARN_ROLE = <ARN_ROLE>
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('S3://<bucket name>/<path>')
COMMENT = 'Storage integration for S3 pokemon bucket';
```
- Replace `<name` with your desired name. I am naming it `S3_INTEGRATION`
- Replace `<ARN_ROLE>` with the ARN role we copied after creating the `Snowflake-s3-stoage-integtation` role.
- I am providing the entire bucket path to `STORAGE_ALLOWED_LOCATIONS`. It looks like `('S3://pokemon-csv-data')`
- Execute the command to create storage integration.

### STEP 7: EDITING ROLE TRUST POLICY
- This is the final step to integrate our S3 bucket with Snowflake. 
- Go to roles. Navigate the role we just created.
- Go to 'Trust relationships' and click on 'edit trust policy'

Do you remember we placed 0000 for the external id when we were creating the role? Now it's time to replace it. 
In Snowflake, execute this command to get details of the storage integration.
```
DESC STORAGE INTEGRATION S3_INTEGRATION;
```
We need to replace two values of the trust policy. The above command will show rows "STORAGE_AWS_EXTERNAL_ID" and "STORAGE_AWS_IAM_USER_ARN"
In the trust policy, replace Principal.AWS key's value with STORAGE_AWS_IAM_USER_ARN and sts:ExternalId key's value with STORAGE_AWS_EXTERNAL_ID. 
Click on 'Update policy' 

### STEP 8: CREATE EXTERNAL STAGE
Use the following command to create external stage.
```
USE SCHEMA EXTERNAL_STAGING;

-- Creating an external stage
CREATE OR REPLACE STAGE POKEDEX.EXTERNAL_STAGING.EXTERNAL_STAGE
URL = 'S3://pokemon-csv-data'
STORAGE_INTEGRATION = S3_INTEGRATION
FILE_FORMAT = POKEDEX.FILE_FORMATS.CSV_DATA;
```
### STEP 9: COPY DATA INTO THE POKEMON TABLE
Like named internal stages, use the following command with stage name and '@' to copy data from the stage to the table. 
```
COPY INTO POKEDEX.PUBLIC.POKEMON
FROM @POKEDEX.EXTERNAL_STAGING.EXTERNAL_STAGE/pokedex.csv;
```

We have successfully loaded the Pokemon table. To check this, you can run
```
SELECT * FROM POKEDEX.PUBLIC.POKEMON;
```


