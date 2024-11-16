*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem

*** Variables ***
${BASE_URL}    https://api.ap.cloud.talend.com/
${EXECUTION_ID}    ${EMPTY}  # Initialize as empty

*** Test Cases ***
Check_Execution_Status
  [Documentation]    Check the status of a specific execution
  ${TOKEN}     Get Environment Variable    TALEND_API_TOKEN
  ${TOKEN}     Set Variable    Bearer ${TOKEN}
  create session  my_session  ${BASE_URL}
  ${headers}=    Create Dictionary    Authorization=${TOKEN}
  ${response}=    GET On Session    my_session    processing/executions/${EXECUTION_ID}    headers=${headers}

  Should Be Equal As Numbers    ${response.status_code}    200
  Log To Console    ${response.content}

  ${response_content}=    Convert To String    ${response.content}
  Log To Console    ${response_content}
  ${json_response}=    Convert String To JSON    ${response_content}
  ${status}=    Get Value From JSON    ${json_response}    $.status  # it returns string
  ${status}=    Set Variable    ${status}[0]
  Should Be Equal    ${status}    execution_successful
