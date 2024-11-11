-- Creating FILE FORMAT 
CREATE OR REPLACE FILE FORMAT CSV_DATA
TYPE = 'CSV'
FIELD_DELIMITER = ','
COMPRESSION = 'AUTO'
SKIP_HEADER = 1,
TRIM_SPACE = TRUE;

-- Creating separate schema for internal staging (optional)
CREATE SCHEMA INTERVAL_STAGING;

-- Using public schema to create table (optional)
USE SCHEMA PUBLIC;

-- CREATE Pokemon Table
CREATE OR REPLACE TABLE POKEMON.PUBLIC.POKEMONS(
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

-- Creating Internal Named Stage (If you want to save data in internal named stage)
CREATE OR REPLACE STAGE POKEMON.INTERNAL_STAGING.named_stage
FILE_FORMAT = POKEMON.INTERNAL_STAGING.CSV_DATA
FILES = ('pokedex.csv');
COMMENT = 'THIS IS A NAMED STAGE SHARED BETWEEN ACCOUNTS';

-- Uploading data via the user stage
-- To add CSV file in User Stage 
PUT 'file://E:/github projects/pokemon/csv/pokedex.csv' @~;

-- To add CSV file in Table Stage
PUT 'file://E:/github projects/pokemon/csv/pokedex.csv' @POKEMON.PUBLIC.%POKEMONS;

--  To add CSV file in Named Stage
PUT 'file://E:/github projects/pokemon/csv/pokedex.csv' @POKEMON.INTERNAL_STAGING.NAMED_STAGE;
