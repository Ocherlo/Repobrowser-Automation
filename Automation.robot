*** Settings ***
Documentation     A test suite for
Default Tags      positive
Library          SeleniumLibrary

*** Test Cases ***
Validate the app is up and running
    Open Browser    http://localhost:3000/  Chrome
    Title Should Be 	 Get Github Repos
Validate the search action
    [Documentation]     Validate the search function
    Element Should Be Visible 	 xpath=//*[@id="username"]
    Input Text  xpath=//*[@id="username"]   robot
    Element Should Be Visible 	 xpath=//*[@id="root"]/div/main/form/button
    Click Button 	 xpath=//*[@id="root"]/div/main/form/button
    Wait Until Element Is Visible 	 xpath=//*[@id="root"]/div/main/section[2]/div/ul   5
    #Search by enter 
    Input Text  xpath=//*[@id="username"]   python
    Press Keys   xpath=//*[@id="username"]   ENTER
    Wait Until Element Is Visible 	 xpath=//*[@id="root"]/div/main/section[2]/div/ul   5
Validate not found search
    [Documentation]     Search a repo to display no repos found and success message
    Input Text  xpath=//*[@id="username"]   abcdfgh
    Click Button 	 xpath=//*[@id="root"]/div/main/form/Button
    Element Should Be Visible 	 xpath=//*[@id="root"]/div/main/section[1]
    Element Text Should Be 	 xpath=//*[@id="root"]/div/main/section[1] 	 Success!
    Wait Until Element Is Visible 	 xpath=//*[@id="root"]/div/main/section[2]/p   5
    Element Text Should Be   xpath=//*[@id="root"]/div/main/section[2]/p    No repos
Validate XSS
    [Documentation]     Simple test for cross-site scripting
    Input Text  xpath=//*[@id="username"]   <script>alert('hello world')</script>
    Click Button 	 xpath=//*[@id="root"]/div/main/form/button
    Alert Should Not Be Present
Go to the repo
    [Documentation]     Search a repo and navigete to the site
    Go To 	 http://localhost:3000/
    Maximize Browser Window
    Input Text  xpath=//*[@id="username"]   robot
    Click Button 	 xpath=//*[@id="root"]/div/main/form/button
    ${title}=   Get Text 	 xpath=//*[@id="root"]/div/main/section[2]/div/ul/li[1]/p[2]
    Wait Until Element Is Visible 	 xpath=//*[@id="root"]/div/main/section[2]/div/ul   5
    Click element   xpath=//*[@id="root"]/div/main/section[2]/div/ul/li[1]/p[1]/a
    Switch Window 	 NEW
    Page Should Contain 	 text=${title}
Validate search with github error
    [Documentation]     Validate the search without name
    [Tags]  negative
    Click Button 	 xpath=//*[@id="root"]/div/main/form/Button
    Element Should Be Visible 	 xpath=//*[@id="root"]/div/main/section[1]
    Element Text Should Be 	 xpath=//*[@id="root"]/div/main/section[1] 	 Github user not found
Force the search with many queries
    [Documentation]     Send multiple request in a short time
    [Tags]  negative
    Go To 	 http://localhost:3000/
    Maximize Browser Window
    FOR     ${i}    IN RANGE    60
        Input Text  xpath=//*[@id="username"]   ${i}
        Click Button 	 xpath=//*[@id="root"]/div/main/form/Button
    END
Validate search with error exceding the api limit
    [Documentation]     Validate the search function displaying something went wrong exceding api limit
    [Tags]  negative
    Input Text  xpath=//*[@id="username"]       repo
    Click Button 	 xpath=//*[@id="root"]/div/main/form/Button
    Element Should Be Visible 	 xpath=//*[@id="root"]/div/main/section[1]
    Element Text Should Be 	 xpath=//*[@id="root"]/div/main/section[1] 	 Something went wrong