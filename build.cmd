@echo off

at >nul
if not %errorlevel% == 0 (
    echo You must run this command with elevated priveleges due to a bug in TX.EXE from the FDK:
    echo Quoting from "tx -h":
    echo.
    echo For certain operations tx uses anonymous temporary files that are automatically
    echo deleted when they are closed. The location of these files is operating system
    echo dependent. On Windows they are created in the root directory ^(most likely c:^).
    echo If you do not have permission to write into the root directory tx will fail
    echo with a file permission error. You can remedy this situation by re-running tx as
    echo a user with the appropriate permissions.
    exit /b 1
)

set family=SourceCodePro
set weights=Black Bold ExtraLight Light Medium Regular Semibold

REM clean existing build artifacts
rmdir /s /q target
mkdir target
mkdir target\OTF
mkdir target\TTF

for %%w in (%weights%) do (
  makeotf -f Roman\%%w\font.pfa -r -o target\OTF\%family%-%%w.otf
  makeotf -f Roman\%%w\font.ttf -gf GlyphOrderAndAliasDB_TT -r -o target\TTF\%family%-%%w.ttf
  del Roman\%%w\current.fpr
)
