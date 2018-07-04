@echo off
COLOR A
setlocal enabledelayedexpansion
title Noughts and crosses 2



:main
    call :titleScreen
    if "%EXIT%"=="1" exit /b
    call :firstSetup

    :main_Loop
    call :resetBoard
    call :gameLoop
    call :endGameScreen %win%
    if /i %rematch%==Y (
        goto main_Loop
    )
    exit /b


:titleScreen
    echo Welcome to Noughts and Crosses.
    echo.
    echo.
    echo Type EXIT to quit the game.
    echo.
    
    :askP1Type
        set p1Type=
        set /p p1Type="Player 1 - Human or Computer? [H/C] - "
        if /i "!p1Type!"=="H" goto askP2Type
        if /i "!p1Type!"=="C" goto askP2Type
        if /i "!p1Type!"=="EXIT" (
            set EXIT=1
            exit /b
        )
    goto askP1Type

    :askP2Type
        set p2Type=
        set /p p2Type="Player 2 - Human or Computer? [H/C] - "
        if /i "!p2Type!"=="H" exit /b
        if /i "!p2Type!"=="C" exit /b
        if /i "!p2Type!"=="EXIT" (
            set EXIT=1
            exit /b
        )
    goto askP2Type



:firstSetup
    set p1Score=0
    set p2Score=0
    set turn=
    set p1Char=X
    set p2Char=O
    set p1Score=0
    set p2Score=0
    set NL=^


    ::winList contains all the possible winning lines, separated by the new line character.
    set winList=1 2 3 !NL! 4 5 6 !NL! 7 8 9 !NL! 1 4 7 !NL! 2 5 8 !NL! 3 6 9 !NL! 1 5 9 !NL! 3 5 7
    exit /b

:ResetBoard
    for /l %%I in (1,1,9) do (
        set G%%I=%%I
    )
    if "%turn%"=="" (
        set /a turn=%random% %% 2 + 1
    ) else (
        set /a turn= 3 - %turn%
    )
    set turnCount=0
    set availableMoves=123456789
    set errorMessage=
    set win=0
    exit /b

:gameLoop
    set /a otherTurn= 3 - %turn%
    if /i "!p%turn%Type!"=="H" (
        call :humanTurn
    ) else (
        call :computerTurn %turn% !p%turn%Char! !p%otherTurn%Char!
    )
    set /a turnCount+=1
    set availableMoves=!availableMoves:%move%=!
    if NOT %win%==0 exit /b
    if %turnCount%==9 exit /b
    set /a turn= 3 - %turn%
    goto GameLoop

:humanTurn
    call :displayGrid
    echo.
    echo.%infoMessage%
    set infoMessage=
    set move=
    set /p move= Player %turn%'s turn. Enter the number of your move [1-9] - 
    if !move! lss 1 (
        set infoMessage=Invalid move, enter a number between 1 and 9.
        goto humanTurn
    )
    if !move! gtr 9 (
        set infoMessage=Invalid move, enter a number between 1 and 9.
        goto humanTurn
    )
    if NOT "!G%Move%!"=="!Move!" (
        set infoMessage=That move has already been made, choose another.
        goto humanTurn
    )
    set G%move%=!p%turn%Char!
    call :CheckWin %turn% !p%turn%Char!
    exit /b

:computerTurn

    set move=
    for /f "tokens=1-3 delims= " %%I in ("!winList!") do (        
        if "!G%%I!!G%%J!!G%%K!"=="%2%2%%K" (
            set move=%%K
        )
        if "!G%%I!!G%%J!!G%%K!"=="%2%%J%2" (
            set move=%%J
        )
        if "!G%%I!!G%%J!!G%%K!"=="%%I%2%2" (
            set move=%%I
        )

        if NOT "!move!"=="" (
            set G!move!=%2
            set win=%1
            exit /b
        )

    )

    for /f "tokens=1-3 delims= " %%I in ("!winList!") do (
        if "!G%%I!!G%%J!!G%%K!"=="%3%3%%K" (
            set move=%%K
        )
        if "!G%%I!!G%%J!!G%%K!"=="%3%%J%3" (
            set move=%%J
        )
        if "!G%%I!!G%%J!!G%%K!"=="%%I%3%3" (
            set move=%%I
        )

        if NOT "!move!"=="" (
            set G!move!=%2
            exit /b
        )
    )
    set /a moveGuess= %random% %% ( 9 - %turnCount% )
    set move=!availableMoves:~%moveGuess%,1!
    set G%move%=!p%turn%Char!
    exit /b

:displayGrid
    cls
    echo.
    echo                          ^|   ^|
    echo                        %G1% ^| %G2% ^| %G3%
    echo                      -------------
    echo                        %G4% ^| %G5% ^| %G6%
    echo                      -------------
    echo                        %G7% ^| %G8% ^| %G9%
    echo                          ^|   ^|
    exit /b

:checkWin
    for /f "tokens=1-3 delims= " %%I in ("!winList!") do (
        if "!G%%I!!G%%J!!G%%K!"=="%2%2%2" (
            set win=%1
            exit /b
        )
    )
    set win=0
    exit /b

:endGameScreen
    if NOT %win%==0 (
        set /a p%win%Score+=1
    )
    call :Displaygrid
    echo.
    echo.
    if %win% gtr 0 (
        echo Player %win% wins^!
    ) else (
        echo It's a draw^!
    )
    echo.
    echo.
    echo                   Current Scores
    echo                   --------------
     echo Player 1 Score - %p1Score%                Player 2 Score - %p2Score%
    echo.
    set rematch=
    set /p rematch="Would you like a rematch? [Y/N] - "
    if /i "!rematch!"=="Y" exit /b
    if /i "!rematch!"=="N" (
        exit /b
    ) else (
        goto endGameScreen
    )
