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

Check_Response_Time
  [Documentation]    Check the response time of a specific execution
  ${TOKEN}     Get Environment Variable    TALEND_API_TOKEN
  ${TOKEN}     Set Variable    Bearer ${TOKEN}
  create session  my_session  ${BASE_URL}
  ${headers}=    Create Dictionary    Authorization=${TOKEN}

  ${start_time}=  Get Time    epoch
  ${response}=    GET On Session    my_session    processing/executions/${EXECUTION_ID}    headers=${headers}
  ${end_time}=    Get Time   epoch
  ${elapsed_time}=    Evaluate    ${end_time} - ${start_time}

  Log To Console      Response time: ${elapsed_time} seconds
  Should Be True      ${elapsed_time}     < 2
