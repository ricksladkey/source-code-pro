@echo off

net session >nul 2>&1
if not %errorlevel% == 0 (
    echo You must run this command with elevated privileges due to a bug in TX.EXE from the FDK:
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
set alt_family=SourceCodeProsaic
set weights=Black Bold ExtraLight Light Medium Regular Semibold
set ascent=984
set alt_ascent=750
set sed=sed -e 's/Source Code Pro/Source Code Prosaic/' -e 's/SourceCodePro/SourceCodeProsaic/'
set sed=%sed% -e 's/ascent value="%ascent%"/ascent value="%alt_ascent%"/'
set sed=%sed% -e 's/usWinAscent value="%ascent%"/usWinAscent value="%alt_ascent%"/'

REM Clean existing build artifacts.
rmdir /s /q target
mkdir target
mkdir target\OTF
mkdir target\TTF

for %%w in (%weights%) do (
  makeotf -f Roman\%%w\font.pfa -r -o target\OTF\%family%-%%w.otf
  makeotf -f Roman\%%w\font.ttf -gf GlyphOrderAndAliasDB_TT -r -o target\TTF\%family%-%%w.ttf
  del Roman\%%w\current.fpr

  ttx target\OTF\%family%-%%w.otf
  %sed% <target\OTF\%family%-%%w.ttx >target\OTF\%alt_family%-%%w.ttx
  ttx target\OTF\%alt_family%-%%w.ttx
  del target\OTF\%family%-%%w.ttx
  del target\OTF\%alt_family%-%%w.ttx

  ttx target\TTF\%family%-%%w.ttf
  %sed% <target\TTF\%family%-%%w.ttx >target\TTF\%alt_family%-%%w.ttx
  ttx target\TTF\%alt_family%-%%w.ttx
  del target\TTF\%family%-%%w.ttx
  del target\TTF\%alt_family%-%%w.ttx
)

