*** Settings ***
Resource  ../Resources/resources.robot

*** Variables ***
${customerResource}      /customer
${existedCustomerId}
${nonExistedCustomerId}


*** Test Cases ***
GetCustomerResource
    OpenSession
    ${response}=    GetRequestt     ${customerResource}
    should be equal as integers  ${response.status_code}    200


PostNewCustomer
    OpenSession
    ${body}=    create dictionary  name=name1
    ${header}=  create dictionary   Content-Type=application/json
    ${response}=   PostRequestt     /customer   ${body}    ${header}
    should be equal as integers  ${response.status_code}    201
    ${jsonContent}=     to json     ${response.content}
    ${existedCustomerId}=  get variable value   ${jsonContent['id']}
    log to console  ${existedCustomerId}
    set global variable  ${existedCustomerId}
    log to console  ${jsonContent}


GetExistedCustomer
    OpenSession
    ${response}=    GetRequestt     /customer/${existedCustomerId}
    should be equal as integers  ${response.status_code}    200


UpdateCustomer
    #Test Api
    OpenSession
    ${body}=    create dictionary  name=name2
    ${header}=  create dictionary   Content-Type=application/json
    ${response}=    PutRequestt     /customer/${existedCustomerId}  ${body}  ${header}
    ${jsonContent}=     to json     ${response.content}

    #Test Database Consistency
    $

    log to console  ${jsonContent}


DeleteExistedCustomer
    OpenSession
    ${response}=    DeleteRequestt  /customer/${existedCustomerId}
    should be equal as integers  ${response.status_code}    200
    ${nonExistedCustomerId}=    get variable value    ${existedCustomerId}
    set global variable       ${nonExistedCustomerId}

GetNonExistentCustomer
    OpenSession
    ${response}=    GetRequestt     /customer/${nonExistedCustomerId}
    should be equal as integers  ${response.status_code}    400

DeleteNonExistedCustomer
    OpenSession
    ${response}=    DeleteRequestt  /customer/${nonExistedCustomerId}
    should be equal as integers  ${response.status_code}    400



*** Keywords ***
