#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download
cd ..
echo Makking the main haxelib and setuping folder in same time..
haxelib setup ~/haxelib
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib git linc_luajit https://github.com/PsychExtendedThings/linc_luajit --quiet #Sirox's linc_luajit (backup)
haxelib git flixel https://github.com/PsychExtendedThings/flixel 5.6.1 --quiet
haxelib install flixel-addons 3.2.2 --quiet
haxelib install flixel-ui 2.4.0 --quiet #I don't know why is it exist
haxelib git SScript https://github.com/PsychExtendedThings/SScript --quiet #stable SScript version (KarimAkra recommended this version)
haxelib git hscript-improved https://github.com/PsychExtendedThings/hscript-improved-Psych --quiet #changed with updated one
haxelib install hscript 2.4.0 --quiet
haxelib install tjson 1.4.0 --quiet #for fucking mods system (haxe.Json brokes the modlist)
haxelib git hxCodec https://github.com/PsychExtendedThings/hxCodec-0.6.3 --quiet #That clearly my repo
haxelib git hxcpp https://github.com/beihu235/hxcpp --quiet #Just a normal hxcpp
haxelib git lime https://github.com/ArkoseLabsOfficial/lime --quiet #repo owner helped to fix termux problem
haxelib install openfl 9.3.3 --quiet #Most stable version of openfl
haxelib git flxanimate https://github.com/PsychExtendedThings/flxanimate-ex --quiet
haxelib git funkin.vis https://github.com/beihu235/funkVis-FrequencyFixed main --quiet
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git 57f5d47f2533fd0c3dcd025a86cb86c0dfa0b6d2 --quiet
echo Finished!
