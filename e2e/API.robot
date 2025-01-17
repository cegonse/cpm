*** Settings ***
Library    Process
Library    OperatingSystem
Test Setup    Set Python Path
Test Teardown    Delete Project

*** Variables ***
${PROJECT_NAME}     AwesomeProject
${CPM}    ${EXECDIR}/scripts/cpm

*** Test Cases ***
Create-Project
    ${result}=    Run Process    ${CPM}    create    ${PROJECT_NAME}
    Should Be Equal 	${result.rc} 	${0}

Target-Add-Fails-When-Directory-Does-Not-Contain-A-CPM-Project
    ${result}=    Run Process    ${CPM}    target    add    ${PROJECT_NAME}
    Should Be Equal 	${result.rc} 	${1}

Target-Add
    Run Process    ${CPM}    create    ${PROJECT_NAME}
    Run Process    ${CPM}    target    add    ubuntu    cwd=${PROJECT_NAME}    alias=add_target
    ${result}=    Get Process Result    add_target
    Should Be Equal 	${result.rc} 	${0}

Build-With-Sample-Code
    Run Process    ${CPM}    create    -s    ${PROJECT_NAME}
    Run Process    ${CPM}    build    cwd=${PROJECT_NAME}    alias=build
    ${result}=    Get Process Result    build
    Should Be Equal 	${result.rc} 	${0}

Build-After-Build
    Run Process    ${CPM}    create    ${PROJECT_NAME}
    Run Process    ${CPM}    build    cwd=${PROJECT_NAME}
    Run Process    ${CPM}    build    cwd=${PROJECT_NAME}    alias=build
    ${result}=    Get Process Result    build
    Should Be Equal 	${result.rc} 	${0}

Build-Fails-When-Directory-Does-Not-Contain-A-CPM-Project
    Run Process    ${CPM}    build    alias=build
    ${result}=    Get Process Result    build
    Should Be Equal 	${result.rc} 	${1}

Clean-After-Build-With-Sample-Code
    Run Process    ${CPM}    create    ${PROJECT_NAME}
    Run Process    ${CPM}    build    cwd=${PROJECT_NAME}
    Run Process    ${CPM}    clean    cwd=${PROJECT_NAME}    alias=clean
    ${result}=    Get Process Result    clean
    Should Be Equal 	${result.rc} 	${0}

Clean-Repeatedly-After-Build-With-Sample-Code
    Run Process    ${CPM}    create    ${PROJECT_NAME}
    Run Process    ${CPM}    build    cwd=${PROJECT_NAME}
    Run Process    ${CPM}    clean    cwd=${PROJECT_NAME}
    Run Process    ${CPM}    clean    cwd=${PROJECT_NAME}    alias=clean
    ${result}=    Get Process Result    clean
    Should Be Equal 	${result.rc} 	${0}

Clean-Fails-When-Directory-Does-Not-Contain-A-CPM-Project
    Run Process    ${CPM}    clean    alias=clean
    ${result}=    Get Process Result    build
    Should Be Equal 	${result.rc} 	${1}

Test-Fails-When-Directory-Does-Not-Contain-A-CPM-Project
    Run Process    ${CPM}    build    alias=build
    ${result}=    Get Process Result    build
    Should Be Equal 	${result.rc} 	${1}

*** Keywords ***
Delete Project
    Remove Directory 	${PROJECT_NAME} 	recursive=True

Set Python Path
    Set Environment Variable    PYTHONPATH    ${EXECDIR}