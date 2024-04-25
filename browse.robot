*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Test Setup    Open Main Page
Test Teardown    Close Browser

*** Variables ***
${URL}    http://localhost:3000
${BROWSER}    Chrome
@{MAIN_MENU_ITEMS}=    ACCESSORIES    GROCERIES    APPAREL
${BAD_PASSWORD}    00000000


*** Test Cases ***

Check Header Is Shown Correctly
    Page Should Contain Element    id:header
    Menu Items Should Be Correct
    Logo Should Be Displayed
    Profile Link Should Be Displayed
    Cart Link Should Be Displayed
    Search Icon Should Be Displayed

Check Product Searching
    Click Search Button
    Write t-shirt To The Search Bar
    Show All Results Button Should Be Displayed
    Click Show All Results Button
    Page Should Be T-Shirt Search Page
    Products Match The Search Term
    Products Are In Tiled Format
    Products Come With An Image

Registration Is Not Possible With Bad Password
    Click Account Icon
    Click Register New Account
    Input Email
    Input Bad Password
    Click Register
    Registration Fails And Password Requirements Are Displayed


*** Keywords ***
Open Main Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window


Menu Items Should Be Correct
    Wait Until Page Contains Element    class:main-menu__item
    
    @{found_menu_items}=    Get WebElements    css:.main-menu__left .main-menu__item
    ${expected_count}=    Get Length    ${MAIN_MENU_ITEMS}
    Length Should Be    ${found_menu_items}    ${expected_count}

    FOR    ${item}    IN    @{found_menu_items}
            ${item_text}=    Get Text    ${item}
            Should Contain    ${MAIN_MENU_ITEMS}    ${item_text}
    END

Logo Should Be Displayed
    Page Should Contain Element     css:.main-menu__center svg[data-src="/images/logo.svg"]

Profile Link Should Be Displayed
    Page Should Contain Element    css:.main-menu__right li[data-testid="login-btn"]

Cart Link Should Be Displayed
    Page Should Contain Element    css:.main-menu__right .main-menu__cart 

Search Icon Should Be Displayed
    Page Should Contain Element    css:.main-menu__right .main-menu__search

Click Search Button
    Click Element    css:.main-menu__right .main-menu__search
    Sleep    50ms

Write t-shirt To The Search Bar
    Input Text    css:.input__field.input__field--left-icon    t-shirt

Show All Results Button Should Be Displayed
    Wait Until Page Contains Element    xpath://div[@class='search__products__footer']

Click Show All Results Button
    Click Element    xpath://div[@class='search__products__footer']

Page Should Be T-Shirt Search Page
    Wait Until Page Contains Element    css=#root > div.category > div.search-page
    ${current_url}    Get Location
    Should Be Equal As Strings    ${current_url}    http://localhost:3000/search/?q=t-shirt

Products Match The Search Term
    ${product_name} =    Get Text    css:h4.sc-fYiAbW.bRQfwK
    Should Contain    ${product_name}    SHIRT

Products Are In Tiled Format
    ${tile} =    Get Webelement    css:div[data-cy="product-tile"]
    Page Should Contain Element    ${tile}    src

Products Come With An Image
    Page Should Contain Element    css=#root > div.category > div.container > div.sc-hjRWVT.bqeKoI > a:nth-child(1) > div > div > img
    
Click Account Icon
    Wait Until Page Contains Element    css=#header > div.main-menu__right > ul > li:nth-child(1) > div > div > svg
    Click Element    css=#header > div.main-menu__right > ul > li:nth-child(1) > div > div > svg

Click Register New Account
    Wait Until Page Contains Element    css=#root > div.overlay.overlay--login > div > div > div.login__tabs > span:nth-child(2)
    Wait Until Element Is Visible    css=#root > div.overlay.overlay--login > div > div > div.login__tabs > span:nth-child(2)
    Click Element    css=#root > div.overlay.overlay--login > div > div > div.login__tabs > span:nth-child(2)

Input Email
    #Email must be unique from the emails of registered accounts. A random email is created so consecutive test runs do not fail because of the test email existing for an account
    #It would be better to delete the created account at the end but this must be enough for the points of this assignment
    ${random_part}    Evaluate    random.choice(string.ascii_lowercase) + random.choice(string.ascii_lowercase) + random.choice(string.ascii_lowercase)
    ${email}    Set Variable    ${random_part}@${random_part}.com   
    Wait Until Page Contains Element    css=#root > div.overlay.overlay--login > div > div > div.login__content > form > div:nth-child(1) > div > input
    Input Text    css=#root > div.overlay.overlay--login > div > div > div.login__content > form > div:nth-child(1) > div > input    ${email}

Input Bad Password
    Wait Until Page Contains Element    css=#root > div.overlay.overlay--login > div > div > div.login__content > form > div:nth-child(2) > div > input
    Input Text    css=#root > div.overlay.overlay--login > div > div > div.login__content > form > div:nth-child(2) > div > input    ${BAD_PASSWORD}

Click Register
    Wait Until Page Contains Element    css=#root > div.overlay.overlay--login > div > div > div.login__content > form > div.login__content__button > button > span
    Click Element    css=#root > div.overlay.overlay--login > div > div > div.login__content > form > div.login__content__button > button > span
    Sleep    50ms

Registration Fails And Password Requirements Are Displayed
    ${requirement_text}    Set Variable    Password must be at least 8 characters and contain at least one upper and lower case letter and at least one number.
    Wait Until Element Is Visible    css=#root > div.overlay.overlay--login > div > div > div.login__content > form > div:nth-child(2) > span
    ${element_text}    Get Text    css=#root > div.overlay.overlay--login > div > div > div.login__content > form > div:nth-child(2) > span
    Should Be Equal As Strings    ${element_text}    ${requirement_text}