*** Settings ***
Library        DatabaseLibrary
#Library        MongoDBBSONLibrary

Suite Setup        Connect master
Suite Teardown    Disconnect From Db


*** Variables ***
${DB_HOST}        localhost     # or 127.0.0.1 or Pacific
${DB_PORT}        3306
${DB_NAME}        world
${DB_USER}        root
${DB_PASSWORD}    Beas1@123#

*** Keywords ***
Connect master
  Connect To Database
  ...    pymysql    
  ...    db_host=localhost 
  ...    db_port=3306
  ...    db_name=world   
  ...    db_user=root  
  ...    db_password=Beas1@123#

Disconnect From Db
  Disconnect From Database


*** Test Cases ***
Connect to mysql and fetch data
    [Documentation]   Fetch data for city Kabul
    [Tags]    Kabul
  #Connect To Database  pymysql    db_host=${DB_HOST}  db_port=${DB_PORT}  db_name=${DB_NAME}  db_user=${DB_USER}  db_password=${DB_PASSWORD}
    @{results}=  Query  SELECT * FROM city WHERE Name = 'Kabul';
    Log  ${results}  console=yes 

Check Table Exists
    [Documentation]     Check if the table 'city' exists
    ${result}=    Query    SHOW TABLES LIKE 'city'
    Log    ${result}
    Should Not Be Empty    ${result} 

Check Row Count in City Table
    [Documentation]    Check the number of rows in the 'city' table
    ${result}=    Query    SELECT COUNT(*) FROM city
    Log    ${result}
    Should Be Equal As Numbers    ${result[0][0]}    4079    # Adjust the expected row count if needed

Check Specific City Data
    [Documentation]   Check the data for a specific city
    [Tags]    Kabul
    ${result}=    Query    SELECT * FROM city WHERE Name='Kabul'
    Log    ${result}
    Should Not Be Empty    ${result}
    Should Be Equal    ${result[0][2]}    AFG
    Should Be Equal    ${result[0][3]}    Kabol
    Should Be Equal As Numbers    ${result[0][4]}    1780000

Check Country Language Data
    ${result}=    Query    SELECT * FROM countrylanguage WHERE CountryCode='USA' AND Language='English'
    Log    ${result}
    Should Not Be Empty    ${result}
    Should Be Equal    ${result[0][2]}    T
    Should Be Equal As Numbers    ${result[0][3]}    86.2

Check Country Population
    ${result}=    Query    SELECT Population FROM country WHERE Name='India'
    Log    ${result}
    Should Not Be Empty    ${result}
    Should Be Equal As Numbers    ${result[0][0]}    1013662000  

Check City Population Greater Than
    ${result}=    Query    SELECT Name, Population FROM city WHERE Population > 10000000
    Log    ${result}
    Should Not Be Empty    ${result}
    Should Be True    ${result[0][1]} > 10000000 

Check Country Independence Year
    ${result}=    Query    SELECT Name, IndepYear FROM country WHERE Name='India'
    Log    ${result}
    Should Not Be Empty    ${result}
    Should Be Equal As Numbers    ${result[0][1]}    1947

Check Country Surface Area
    ${result}=    Query    SELECT Name, SurfaceArea FROM country WHERE Name='Canada'
    Log    ${result}
    Should Not Be Empty    ${result}
    Should Be Equal As Numbers    ${result[0][1]}    9970610

Check for Null Values in City Table
    ${result}=    Query    SELECT COUNT(*) FROM city WHERE Population IS NULL
    Log    ${result}
    Should Be Equal As Numbers    ${result[0][0]}    0  # Expecting no null values

Check for Unique Country Codes
    ${result}=    Query    SELECT COUNT(DISTINCT Code) FROM country
    ${total}=    Query    SELECT COUNT(*) FROM country
    Log    ${result}
    Log    ${total}
    Should Be Equal As Numbers    ${result[0][0]}    ${total[0][0]}  # Expecting all country codes to be unique

Check Data Types in Country Table
    ${result}=    Query    SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'country' AND COLUMN_NAME = 'Population'
    Log    ${result}
    Should Be Equal    ${result[0][0]}    int  # Expecting Population column to be of type int
