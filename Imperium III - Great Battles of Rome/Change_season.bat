cls
@ECHO OFF
title Change Season

:CONFIRM
echo Which season do you want? (S/A/W or s/a/w or SPRING/AUTUMN/WINTER or spring/autumn/winter)
set/p "cho=>"
if %cho%==S goto SPRING
if %cho%==A goto AUTUMN
if %cho%==W goto WINTER
if %cho%==s goto SPRING
if %cho%==a goto AUTUMN
if %cho%==w goto WINTER
if %cho%==SPRING goto SPRING
if %cho%==AUTUMN goto AUTUMN
if %cho%==WINTER goto WINTER
if %cho%==spring goto SPRING
if %cho%==autumn goto AUTUMN
if %cho%==winter goto WINTER
echo Invalid choice.
goto CONFIRM

:SPRING
set DIRNAME=%~dp0
set game_dir=%DIRNAME%\
set seasons_dir=%DIRNAME%\Seasons\SPRING
echo + game_dir   -- "%game_dir%"
echo + seasons_dir     -- "%seasons_dir%"
robocopy "%seasons_dir%" "%game_dir%" /E
echo DONE
goto End

:AUTUMN
set DIRNAME=%~dp0
set game_dir=%DIRNAME%\
set seasons_dir=%DIRNAME%\Seasons\AUTUMN
echo + game_dir   -- "%game_dir%"
echo + seasons_dir     -- "%seasons_dir%"
robocopy "%seasons_dir%" "%game_dir%" /E
echo DONE
goto End

:WINTER
set DIRNAME=%~dp0
set game_dir=%DIRNAME%\
set seasons_dir=%DIRNAME%\Seasons\WINTER
echo + game_dir   -- "%game_dir%"
echo + seasons_dir     -- "%seasons_dir%"
robocopy "%seasons_dir%" "%game_dir%" /E
echo DONE
goto End