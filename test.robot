*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Data Portal
Suite Teardown    Close Browser

*** Variables ***
${URL}       https://dataportal.m-society.go.th/
${BROWSER}   Chrome
${USERNAME}   useradmintest1
${PASSWORD}   zjkoC]6p

*** Keywords ***
Open Browser To Data Portal
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div/header/div/button[2]    timeout=10s

*** Test Cases ***
เข้าสู่ระบบสำเร็จ
    Click Element    xpath=//*[@id="app"]/div/div/header/div/button[2]
    Wait Until Location Contains    /login/local    timeout=10s
    Input Text    xpath=//*[@id="input-v-4"]    ${USERNAME}
    Input Text    xpath=//*[@id="input-v-6"]    ${PASSWORD}
    Click Element    xpath=//*[@id="app"]/div/div/div/main/div/div/div/div[2]/div/div/div[2]/div[4]/button
    Wait Until Location Is    https://dataportal.m-society.go.th/home    timeout=10s
    Location Should Be    https://dataportal.m-society.go.th/home

ตรวจสอบแสดง Metadata หลังเข้าสู่ระบบ
    [Tags]    Metadata
    Open Browser To Data Portal
    Click Element    xpath=//*[@id="app"]/div/div/header/div/button[2]
    Wait Until Location Contains    /login/local    timeout=10s
    Input Text    xpath=//*[@id="input-v-4"]    ${USERNAME}
    Input Text    xpath=//*[@id="input-v-6"]    ${PASSWORD}
    Click Element    xpath=//*[@id="app"]/div/div/div/main/div/div/div/div[2]/div/div/div[2]/div[4]/button
    Wait Until Location Is    https://dataportal.m-society.go.th/home    timeout=10s
    Location Should Be        https://dataportal.m-society.go.th/home

    # ตรวจสอบว่า element ที่มีข้อความ Metadata ปรากฏ
    Wait Until Element Is Visible    xpath=//div[contains(@class, "text-caption") and contains(text(), "Metadata")]    timeout=10s
    Element Should Contain    xpath=//div[contains(@class, "text-caption") and contains(text(), "Metadata")]    Metadata

ออกจากระบบสำเร็จ
    # รอก่อนว่าปุ่มโปรไฟล์โผล่
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div/header/div/button[9]    timeout=10s

    # ใช้ JS คลิกปุ่มโปรไฟล์ เพื่อเลี่ยง overlay intercept
    Execute JavaScript    document.evaluate('//*[@id="app"]/div/div/header/div/button[9]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click()

    Wait Until Page Does Not Contain Element    xpath=//div[contains(@class, "v-overlay__scrim")]    timeout=10s

    # รอ Logout ปรากฏ
    Wait Until Element Is Visible    xpath=//div[contains(@class, "v-list-item-title") and contains(., "Logout")]    timeout=10s

    # ใช้ JS คลิก Logout
    Execute JavaScript    document.evaluate('//div[contains(@class, "v-list-item-title") and contains(., "Logout")]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click()

    # รอปุ่ม Confirm บนป๊อปอัป
    Wait Until Element Is Visible    xpath=//span[text()="Confirm"]    timeout=10s
    Click Element    xpath=//span[text()="Confirm"]

    # ตรวจสอบว่า redirect ไปหน้า home
    Wait Until Location Is    https://dataportal.m-society.go.th/    timeout=10s
    Location Should Be        https://dataportal.m-society.go.th/

เข้าหน้า Home โดยไม่ล็อกอิน
    [Tags]    Redirect    Auth
    # เปิด browser ตรงไปยัง /home โดยยังไม่ login
    Open Browser    https://dataportal.m-society.go.th/home    ${BROWSER}
    Maximize Browser Window

    # รอการ redirect ไปหน้า login
    Wait Until Location Contains    /login/local    timeout=10s
    Location Should Be              https://dataportal.m-society.go.th/login/local

    Close Browser
