*** Settings ***
#Library        DatabaseLibrary
#Library        MongoDBBSONLibrary
Library        MongoDBLibrary


*** Variables ***
${MONGO_URI}    mongodb+srv://pqrs16374:firstlook@clustermaster.2cxyg.mongodb.net/sample_mflix
${COLLECTION}   movies

*** Test Cases ***
Validate Movie Document in MongoDB
    [Documentation]    Connect to MongoDB and validate a document in the `movies` collection.
    MongoDBLibrary.Connect to Mongodb   ${MONGO_URI}
    ${allResults}  Retrieve Some MongoDB Records  sample_mflix  movies  {"title": "The Matrix"}
    Log  ${allResults}
    Should Contain X Times  ${allResults}  'The Matrix'  1

