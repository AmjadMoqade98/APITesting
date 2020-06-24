*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary
*** Variables ***
${base_url}     http://localhost:8080
${session_name}      Multithreading

*** Keywords ***
OpenSession
    create session  ${session_name}    ${base_url}

GetRequestt
    [Arguments]  ${resource}
    ${response}=    get request   ${session_name}   ${resource}
    [Return]    ${response}

PostRequestt
    [Arguments]   ${resource}    ${body}    ${headers}
    ${response}=     post request    ${session_name}     ${resource}   data=${body}    headers=${headers}
    [Return]  ${response}

DeleteRequestt
    [Arguments]  ${resource}
    ${response}   delete request    ${session_name}    ${resource}
    [Return]  ${response}


PutRequestt
    [Arguments]   ${resource}    ${body}    ${header}
    ${response}=     put request    ${session_name}     ${resource}   data=${body}    headers=${header}
    [Return]  ${response}

