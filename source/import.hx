#if !macro
import Paths;
import FunkinLua;

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

#if DISCORD_ALLOWED
import Discord.DiscordClient;
#end

#if ENABLE_NOVA
import novaengine.FreeplayStateNOVANew;
#end

//options
import objects.state.general.*;
import backend.mouse.*;
import objects.screen.*;
import backend.data.*;
import backend.ui.*;
import shapeEx.*;

// Scripting;
import funkin.backend.scripting.ModState;
import funkin.backend.scripting.events.*;
import codenamecrew.hscript.macros.*;
import funkin.backend.scripting.*;
import funkin.backend.shaders.*;
import options.group.ModGroup;
import funkin.backend.assets.*;
import funkin.backend.utils.*;
import funkin.backend.system.*;
import funkin.backend.*; //I'm making FunkinSprite in PsychExtended because it's fucking cool and useful
import funkin.game.*;

#if CNE_CHART_ALLOWED
import funkin.backend.chart.*;
#end

import backend.BaseStage;
import Song.SwagSong;
import Section.SwagSection;
import tea.SScript;
import editors.StageEditorState;

// FlxAnimate
#if flxanimate
import flxanimate.*;
//import flxanimate.PsychFlxAnimate as FlxAnimate;
#end

import options.base.*;
#if MODS_ALLOWED
import backend.Mods;
#end

#if ACHIEVEMENTS_ALLOWED
import backend.Achievements;
import objects.AchievementPopup;
#end

// Mobile Things
#if TOUCH_CONTROLS
import mobile.input.*;
import mobile.flixel.*;
import mobile.states.*;
import mobile.objects.*;
import mobile.options.*;
import mobile.backend.*;
import mobile.psychlua.*;
import mobile.substates.*;
import mobile.objects.Hitbox;
import mobile.objects.MobilePad;
import mobile.backend.MobileData;
#else
import mobile.backend.StorageUtil;
import mobile.backend.PsychJNI;
import mobile.options.*;
import mobile.backend.MobileScaleMode;
#end

// Android
#if android
import android.Tools as AndroidTools;
import android.Settings as AndroidSettings;
import android.widget.Toast as AndroidToast;
import android.content.Context as AndroidContext;
import android.Permissions as AndroidPermissions;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Environment as AndroidEnvironment;
import android.os.BatteryManager as AndroidBatteryManager;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
#end

// Lua
#if LUA_ALLOWED
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

//Flixel
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.sound.FlxSound;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.effects.FlxSkewedSprite;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.util.FlxDestroyUtil;
import hxvlc.flixel.FlxVideo;
import psychlua.LuaUtils;
import haxe.ds.StringMap;
#end

using StringTools;