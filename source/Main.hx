package;

import openfl.text.TextField;
import openfl.text.TextFormat;
import mobile.backend.CrashHandler;
import openfl.events.UncaughtErrorEvent;
import debug.FPSCounter;
import flixel.addons.transition.FlxTransitionableState;
#if EXTRA_FPSCOUNTER
import objects.screen.Graphics;
import objects.screen.FPS;
#end
import Highscore;
import flixel.FlxGame;
import haxe.io.Path;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import TitleState;
import mobile.backend.MobileScaleMode;
import openfl.events.KeyboardEvent;
import lime.system.System as LimeSystem;
#if mobile
import mobile.states.CopyState;
#end
#if linux
import lime.graphics.Image;

@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: #if mobile true #else false #end // if the game should start at fullscreen mode
	};

	public static var fpsVar:FPSCounter;
	#if EXTRA_FPSCOUNTER
	public static var fpsVarNova:FPS;
	#end

	public static final platform:String = #if mobile "Phones" #else "PCs" #end;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
		#if cpp
		cpp.NativeGc.enable(true);
		#elseif hl
		hl.Gc.enable(true);
		#end
	}

	public function new()
	{
		CrashHandler.init();
		#if mobile
		#if android
		StorageUtil.requestPermissions();
		#end
		Sys.setCwd(StorageUtil.getStorageDirectory());
		#end

		#if VIDEOS_ALLOWED
		hxvlc.util.Handle.init(#if (hxvlc >= "1.8.0")  ['--no-lua'] #end);
		#end
		
		super();

		#if windows
		@:functionCode("
			#include <windows.h>
			#include <winuser.h>
			setProcessDPIAware() // allows for more crisp visuals
			DisableProcessWindowsGhosting() // lets you move the window and such if it's not responding
		")
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		#if (openfl <= "9.2.0")
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}
		#else
		if (game.zoom == -1.0)
			game.zoom = 1.0;
		#end

		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(CallbackHandler.call)); #end
		ClientPrefs.loadDefaultKeys();
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end

		var framerateShit:Int = game.framerate;
		if (Reflect.hasField(FlxG.save.data, 'framerate')) framerateShit = Reflect.field(FlxG.save.data, 'framerate'); //double check lol

		if (!TitleState.initialized) { //double check lol
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		var game:FlxGame = new FlxGame(game.width, game.height, #if (mobile && MODS_ALLOWED) CopyState.checkExistingFiles() ? game.initialState : CopyState #else game.initialState #end, #if (flixel < "5.0.0") game.zoom, #end framerateShit, framerateShit, game.skipSplash, game.startFullscreen);
		addChild(game);

		#if CUSTOM_RESOLUTION_ALLOWED
		if (Reflect.hasField(FlxG.save.data, 'realResolution')) {
			var resolution = Reflect.field(FlxG.save.data, 'realResolution');
			var parts = resolution.split('/');
			//Option Safety
			if (Std.parseInt(parts[1]) >= 720) FlxG.changeGameSize(Std.parseInt(parts[0]), Std.parseInt(parts[1]));
		}
		#end

		#if GLOBAL_SCRIPT
		funkin.backend.scripting.HScript.GlobalScript.init();
		#end

		#if EXTRA_FPSCOUNTER
		/* Note to future myself: don't forget the add FPS.tff into fonts folder because if font can't found game instantly crashes, if you forget it again you're a idiot */
		fpsVarNova = new FPS(5, 5);
		addChild(fpsVarNova);
		if (fpsVarNova != null) { fpsVarNova.scaleX = fpsVarNova.scaleY = 1; fpsVarNova.visible = false; }
		#end

		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if(fpsVar != null) fpsVar.visible = false;

		/*
		debugTrace = new FlxTypedGroup<DebugText>();
		addChild(debugTrace);
		*/

		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if web
		FlxG.keys.preventDefaultKeys.push(TAB);
		#else
		FlxG.keys.preventDefaultKeys = [TAB];
		#end

		#if android FlxG.android.preventDefaultKeys = [BACK]; #end

		#if mobile
		FlxG.scaleMode = new MobileScaleMode();
		#end

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = #if mobile 30 #else 60 #end;
		Application.current.window.vsync = false;
		FlxG.signals.preUpdate.add(fixSlowdown);

		// shader and mobile device coords fix
		// fixes notch problem, idk why
		FlxG.signals.gameResized.add(function (w, h) {
			if(fpsVar != null)
				fpsVar.positionFPS(10, 3, Math.min(w / FlxG.width, h / FlxG.height));

			if (FlxG.cameras != null) {
				for (cam in FlxG.cameras.list) {
					if (cam != null)
						resetSpriteCache(cam.flashSprite);
				}
			}

			if (FlxG.game != null)
				resetSpriteCache(FlxG.game);
		});
	}

	/*
	private var debugTrace:FlxTypedGroup<DebugText>;
	public function addTextToDebug(text:String, ?color:FlxColor = FlxColor.RED) {
		var newText:DebugText = debugTrace.recycle(DebugText);
		newText.text = text;
		newText.color = color;
		newText.disableTime = 6;
		newText.alpha = 1;
		newText.x = FlxG.game.x + 10;
		newText.y = FlxG.game.y + 8 - newText.height;

		debugTrace.forEachAlive(function(spr:DebugText) {
			spr.y += newText.height + 2;
		});
		debugTrace.add(newText);
		Sys.println(text);
	}
	*/

	/* Fixes the Modpack Switch Slowdown I guess */
	function fixSlowdown() {
		Application.current.window.vsync = false;
		FlxG.fixedTimestep = false; //FUCK, I forgot this
		if (Reflect.hasField(FlxG.save.data, 'framerate'))
			FlxG.gameFramerate = FlxG.save.data.framerate;
		else
			FlxG.gameFramerate = 60;
	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}
	
	#if mobile
	public inline function setScale(?scale:Float){
		if(scale == null)
			scale = Math.min(FlxG.stage.window.width / FlxG.width, FlxG.stage.window.height / FlxG.height);
		scaleX = scaleY = #if android (scale > 1 ? scale : 1) #else (scale < 1 ? scale : 1) #end;
	}
	#end
}

/*
class DebugText extends TextField
{
	public var disableTime:Float = 6;
	public function new() {
		super();
		x = FlxG.game.x + 10;
		y = FlxG.game.y + 10;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE);
		width = FlxG.width;
		multiline = true;
	}

	override function __update(elapsed:Float) {
		super.__update(elapsed);
		disableTime -= elapsed;
		if(disableTime < 0) disableTime = 0;
		if(disableTime < 1) alpha = disableTime;
		
		if(alpha == 0 || y >= FlxG.height) kill();
	}
}
*/