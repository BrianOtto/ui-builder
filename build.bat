@ECHO OFF

REM The web directory
SET WEB=web

ECHO.
ECHO Building UI Builder ...
ECHO.

REM Clean up the ouput directory
FOR %%i IN ("%WEB%\*") DO DEL /Q "%%i"
FOR %%i IN ("%WEB%\css\*") DO DEL /Q "%%i"
FOR %%i IN ("%WEB%\js\*") DO DEL /Q "%%i"

IF NOT EXIST "%WEB%" MKDIR "%WEB%"
IF NOT EXIST "%WEB%\css" MKDIR "%WEB%\css"
IF NOT EXIST "%WEB%\js" MKDIR "%WEB%\js"

REM Copy our 3rd party libraries to the web directory
XCOPY /Y src\lib\fontawesome\*.js "%WEB%\js" 1>NUL
XCOPY /Y src\lib\ren-c\*.js "%WEB%\js" 1>NUL
XCOPY /Y src\lib\uikit\*.js "%WEB%\js" 1>NUL
XCOPY /Y src\lib\uikit\*.css "%WEB%\css" 1>NUL

REM Copy UI Builder to the web directory
XCOPY /Y src\index.css "%WEB%\css" 1>NUL
XCOPY /Y src\index.js "%WEB%\js" 1>NUL
XCOPY /Y src\index.html "%WEB%" 1>NUL
XCOPY /Y src\index.r "%WEB%" 1>NUL
XCOPY /Y src\export.html "%WEB%" 1>NUL
XCOPY /Y src\export.r "%WEB%" 1>NUL
XCOPY /Y src\ui-db.js "%WEB%\js" 1>NUL
XCOPY /Y src\logo.png "%WEB%" 1>NUL

ECHO Done
ECHO.
ECHO You can run the application by pointing a web server to
ECHO.
ECHO %~dp0%WEB%

EXIT /B %ERRORLEVEL%VEL