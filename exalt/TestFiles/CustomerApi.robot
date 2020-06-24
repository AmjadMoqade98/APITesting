*** Settings ***
Resource  ../Resources/resources.robot
Suite Setup     OpenSession
Suite Teardown  DeleteSessions

*** Variables ***
${existedCustomerId}
${nonExistedCustomerId}
${newName}

*** Test Cases ***
GetCustomerResource
    ${response}=    GetRequestt     /customer
    should be equal as integers  ${response.status_code}    200

PostNewCustomer
    ${body}=    create dictionary  name=amjad
    ${header}=  create dictionary   Content-Type=application/json
    ${response}=   PostRequestt     /customer   ${body}    ${header}
    should be equal as integers  ${response.status_code}    201
    ${content}=     to json     ${response.content}
    ${existedCustomerId}=  get variable value   ${content['id']}
    log to console  ${existedCustomerId}
    set global variable  ${existedCustomerId}
    log to console  ${content}


GetExistedCustomer
    ${response}=    GetRequestt     /customer/${existedCustomerId}
    should be equal as integers  ${response.status_code}    200


UpdateCustomer
    ${newName}  set variable  newName
    set global variable  ${newName}
    ${body}=    create dictionary  name=${newName}
    ${header}=  create dictionary   Content-Type=application/json
    ${response}=    PutRequestt     /customer/${existedCustomerId}  ${body}  ${header}
    ${content}=     to json     ${response.content}
    log to console  ${content}

DatabaseConsistencyOnCustomerUpdate
    ${response}=    GetRequestt  /customer/${existedCustomerId}
    ${jsonContent}=     to json  ${response.content}
    ${customerName}=  get variable value  ${jsonContent['name']}
    should be equal as strings  ${customerName}     ${newName}

DeleteExistedCustomer
    ${response}=    DeleteRequestt  /customer/${existedCustomerId}
    should be equal as integers  ${response.status_code}    200
    ${nonExistedCustomerId}=    get variable value    ${existedCustomerId}
    set global variable       ${nonExistedCustomerId}

GetNonExistentCustomer
    ${response}=    GetRequestt     /customer/${nonExistedCustomerId}
    should be equal as integers  ${response.status_code}    404

DeleteNonExistedCustomer
    ${response}=    DeleteRequestt  /customer/${nonExistedCustomerId}
    should be equal as integers  ${response.status_code}    404


*** Keywords ***
