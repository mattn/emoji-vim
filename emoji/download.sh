#!/usr/bin/env bash

cd $(cd $(dirname $0); pwd)
rm -f master* *.png 2>&1 > /dev/null
curl -L -s "https://github.com/arvida/emoji-cheat-sheet.com/archive/master.zip" > master.zip
unzip master.zip
rm master.zip
mv emoji-cheat-sheet.com-master/public/graphics/emojis/*.png . 
rm -rf emoji-cheat-sheet.com-master
