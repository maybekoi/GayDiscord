package states;

import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.FlxG;

class LoadingState extends FlxState
{
    var bg:FlxSprite;
    var loadingText:FlxText;
    var song:FlxSound;
    var ngLogo:FlxSprite;
    var stupidloading:Bool = false;

    var mainText:FlxText;

	override public function create()
	{
        stupidloading = false;
        bg = new FlxSprite(-80).loadGraphic('assets/images/discordColorYuh.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

        mainText = new FlxText(0, 150, 0, "Welcome to the maybekoi discord.com experience\n\nInspired by ninjamuffin99's The ninja_muffin99 Twitter.com experience 2018");
        mainText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, CENTER);
        mainText.screenCenter(X);
        add(mainText);

        loadingText = new FlxText(0, 450, 0, "Getting high...");
        loadingText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, CENTER);
        loadingText.screenCenter(X);
        add(loadingText);

        ngLogo = new FlxSprite(0, 0).loadGraphic('assets/images/newgroundsLoadinglmao.png');
        ngLogo.screenCenter();
        ngLogo.scale.set(0.5, 0.5);
        ngLogo.antialiasing = false;
        ngLogo.updateHitbox();
        //add(ngLogo);

        // shit did NOT wanna fucking play for some reason.
        /*
		if (FlxG.sound.music != null)
        {
            if (!FlxG.sound.music.playing)
                FlxG.sound.playMusic('assets/music/Bakuretsu.ogg', 0);
        }
        */

		super.create();

        new FlxTimer().start(12.0, fuckAssTextUpdate, 3);
	}

	override public function update(elapsed:Float)
	{
        #if debug
        if (FlxG.keys.justPressed.ONE)
        {
            FlxG.switchState(new PlayState());
        }
        #end
        if (stupidloading && (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE))
            FlxG.switchState(new PlayState());
		super.update(elapsed);
	}

    function fuckAssTextUpdate(timer:FlxTimer)
    {
        stupidloading = true;
        loadingText.text = "Done getting high, press enter to continue...";
        loadingText.screenCenter(X);
    }
}