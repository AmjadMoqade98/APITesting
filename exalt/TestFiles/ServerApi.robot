*** Settings ***
Resource  ../Resources/resources.robot
Suite Setup     OpenSession
Suite Teardown  DeleteSessions

*** Variables ***
${existedServerId}     3R3XrYdrFHXCzHZCx86Dtv
${nonExistedServerId}   mmmmmmmmmmmmmmmmmmmmmm
${customerId}   158fh7eFVXmTzK2FTZSFqt
${maximumServerSize}    100

*** Test Cases ***
GetServerResource
    ${response}=    GetRequestt     /server
    should be equal as integers  ${response.status_code}    200

GetExistedServer
    ${response}=    GetRequestt     /server/${existedServerId}
    should be equal as integers  ${response.status_code}    200


GetNonExistentServer
    ${response}=    GetRequestt     /server/${nonExistedServerId}
    should be equal as integers  ${response.status_code}    404


RentServerWithValidSpace
    ${response}=    GetRequestt  /server/rent?id=${customerId}&space=50
    should be equal as integers  ${response.status_code}     200

RentServerWithInvalidSpace
    ${response}=    GetRequestt  /server/rent?id=${customerId}&space=120
    should be equal as integers  ${response.status_code}     400


DatabaseConsistencyOnServerSpan

    #request that will span new server
    ${response}=    GetRequestt  /server/rent?id=${customerId}&space=${maximumServerSize}
    ${content}=     to json  ${response.content}
    ${spannedServerId}=    get variable value      ${content['id']}
    sleep  5s

    #check if the server added to the database
    ${response}=    GetRequestt  /server/${spannedServerId}
    log to console      ${response.content}
    ${content}=     to json  ${response.content}
    ${remainingCapacity}=   get variable value  ${content['remainingCapacity']}
    should be equal as integers  ${response.status_code}    200
    should be equal as integers  ${remainingCapacity}   0


*** Keywords ***

