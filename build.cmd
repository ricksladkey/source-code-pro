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
