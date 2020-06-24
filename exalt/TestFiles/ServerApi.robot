*** Settings ***
Resource  ../Resources/resources.robot

*** Variables ***
${existedServerId}     48N8hYgfh8xmggnNTpbo7a
${nonExistedServerId}   mmmmmmmmmmmmmmmmmmmmmm

*** Test Cases ***
GetServerResource
    OpenSession
    ${response}=    GetRequestt     /server
    should be equal as integers  ${response.status_code}    200

GetExistedServer
    OpenSession
    ${response}=    GetRequestt     /server/${existedServerId}
    should be equal as integers  ${response.status_code}    200

GetNonExistentServer
    OpenSession
    ${response}=    GetRequestt     /server/${nonExistedServerId}
    should be equal as integers  ${response.status_code}    400




*** Keywords ***

