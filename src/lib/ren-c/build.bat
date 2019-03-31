@ECHO OFF

REM The location of Ren-C
REM See https://github.com/metaeducation/ren-c
SET RENC=..\..\..\..\ren-c

REM The location of Emscripten
REM See https://emscripten.org/docs/getting_started/downloads.html
SET EMMC=..\..\..\..\..\emscripten-core\emsdk

ECHO.
ECHO Building Emscripten ...
ECHO.

REM Initialize the Emscripten environment
CALL "%EMMC%\emsdk_env.bat" 1>NUL

REM Get the last exit code and stop the batch script when there's an error
IF %ERRORLEVEL% NEQ 0 (
    GOTO :EOF
)

REM Append the UI Builder settings
COPY /B "%RENC%\configs\emscripten.r"+config.r config-tmp.r 1>NUL

REM Get the last exit code and stop the batch script when there's an error
IF %ERRORLEVEL% NEQ 0 (
    GOTO :EOF
)

REM Build the libraries
"%RENC%\prebuilt\r3-windows-x86-8994d23" %RENC%\make.r config: config-tmp.r clean prep library

REM Get the last exit code and stop the batch script when there's an error
IF %ERRORLEVEL% NEQ 0 (
    GOTO :EOF
)

REM Embed the libraries into each other
"%RENC%\prebuilt\r3-windows-x86-8994d23" build.r

REM Get the last exit code and stop the batch script when there's an error
IF %ERRORLEVEL% NEQ 0 (
    GOTO :EOF
)

REM Clean up the build files
RMDIR /S /Q objs
RMDIR /S /Q prep
DEL /Q config-tmp.r

ECHO.
ECHO Done

EXIT /B %ERRORLEVEL%VEL