@echo off
color 0a
cd ..
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc --quiet
haxelib git linc_luajit https://github.com/PsychExtendedThings/linc_luajit --quiet
haxelib git flixel https://github.com/PsychExtendedThings/flixel 5.6.1 --quiet
haxelib install flixel-addons 3.2.2 --quiet
haxelib install flixel-ui 2.4.0 --quiet
haxelib git SScript https://github.com/PsychExtendedThings/SScript --quiet
haxelib git hscript-improved https://github.com/PsychExtendedThings/hscript-improved-Psych --quiet
haxelib install hscript 2.4.0 --quiet
haxelib install tjson 1.4.0 --quiet
haxelib git hxCodec https://github.com/PsychExtendedThings/hxCodec-0.6.3 --quiet
haxelib git hxcpp https://github.com/beihu235/hxcpp --quiet
haxelib git lime https://github.com/ArkoseLabsOfficial/lime --quiet
haxelib install openfl 9.3.3 --quiet
haxelib git flxanimate https://github.com/PsychExtendedThings/flxanimate-ex --quiet
haxelib git funkin.vis https://github.com/beihu235/funkVis-FrequencyFixed main --quiet
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git 57f5d47f2533fd0c3dcd025a86cb86c0dfa0b6d2 --quiet
echo Finished!
pause
