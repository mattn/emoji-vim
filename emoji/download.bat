@echo off

cd %~dp0
del /Q /S "master*" 2>&1 > NUL
del /Q /S "*.png" 2>&1 > NUL
del /Q /S "*.bmp" 2>&1 > NUL
:download
curl -L -s "https://github.com/arvida/emoji-cheat-sheet.com/archive/master.zip" > master.zip
unzip master.zip
del /Q /S "master*" 2>&1 > NUL
move emoji-cheat-sheet.com-master\public\graphics\emojis\*.png . 
rd /Q /S emoji-cheat-sheet.com-master
png2bmp
del /Q /S "*.png" 2>&1 > NUL
