package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.effects.FlxFlicker;
import flixel.input.keyboard.FlxKey;
import flixel.input.mouse.FlxMouseEventManager;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;
import WeekData;

using StringTools;

class CustomStoryModeState extends MusicBeatState
{
    public static var curSelected:Int = 0;

    var curDifficulty:Int = 2;
    var loadedWeeks:Array<WeekData> = [];
    var curdiff:Int = 2;
    var oneclickpls:Bool = true;

    var chargroup:FlxTypedGroup<FlxSprite>;
    var weekgroup:FlxTypedGroup<FlxSprite>;

    var charnames:Array<String> = ["personagem1", "personagem2"];
    var weeksnames:Array<String> = ["weeknome1", "weeknome1"];
    var songArray:Array<String> = ["bopeebo", "fresh"];

    var bgsukerlmfa:FlxSprite;
    
    var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
    var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
    var difficulty:String = CoolUtil.getDifficultyFilePath();

    override function create()
    {
        bgsukerlmfa = new FlxSprite(0, 0).loadGraphic(Paths.image("imagem do bg aqui"));
        bgsukerlmfa.screenCenter(XY);
        bgsukerlmfa.alpha = 1;
        add(bgsukerlmfa);

        tracksSprite = new FlxSprite(120, 570).loadGraphic(Paths.image('Menu_Tracks'));
		tracksSprite.antialiasing = ClientPrefs.globalAntialiasing;
        tracksSprite.color = 0xFF0000FF;
		add(tracksSprite);

        CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
        WeekData.setDirectoryFromWeek();
        WeekData.reloadWeekFiles(false);
        for (i in 0...WeekData.weeksList.length){
            var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
            loadedWeeks.push(weekFile);
        }

        super.create();
        chargroup = new FlxTypedGroup<FlxSprite>();
        weekgroup = new FlxTypedGroup<FlxSprite>();

        for(i in 0...charnames.length)
        {
            var character:FlxSprite = new FlxSprite(481.10, 0).loadGraphic(Paths.image('pasta/' + charnames[i]));
            chargroup.add(character);
            character.ID = i;
        }

        for(i in 0...weeksnames.length)
        {
            var weekthing:FlxSprite = new FlxSprite(51.15, 259.05).loadGraphic(Paths.image("pasta/" + weeksnames[i].toLowerCase(), 'preload'));
			weekthing.frames = Paths.getSparrowAtlas('pasta/' + weeksnames[i]);
			weekthing.animation.addByPrefix('minianin', weeksnames[i], 24);
            weekthing.animation.play('minianin');
            weekthing.ID = i;
            weekgroup.add(weekthing);

            /*switch(i)
            {
                case 0: // - CASO VOCE QUEIRA POSSICIONAR 1 DELES
					weekthing.setPosition(15.15, 259.05);	
            }*/
        }

        changeItem(0);

        add(chargroup);
        add(weekgroup);

        leftArrow = new FlxSprite(0, 0);
        leftArrow.frames = ui_tex;
        leftArrow.animation.addByPrefix('idle', "arrow left");
        leftArrow.animation.addByPrefix('press', "arrow push left");
        leftArrow.animation.play('idle');
        leftArrow.setPosition(200, 145);
        leftArrow.angle = 90;
        leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
        add(leftArrow);

        rightArrow = new FlxSprite(leftArrow.x + 376, leftArrow.y);
        rightArrow.frames = ui_tex;
        rightArrow.animation.addByPrefix('idle', 'arrow right');
        rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
        rightArrow.animation.play('idle');
        rightArrow.setPosition(200, 460);
        rightArrow.angle -= -90;
        rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
        add(rightArrow);
    }

    override function update(elapsed:Float)
    {
        //var difficulty:String = CoolUtil.getDifficultyFilePath();

        if (controls.UI_UP_P && oneclickpls)
        {
            changeItem(-1);
        }

        if (controls.UI_DOWN_P && oneclickpls)
        {
            changeItem(1);
        }

        if (controls.UI_UP_P && oneclickpls)
			leftArrow.animation.play('press');
		else
			leftArrow.animation.play('idle');

        if (controls.UI_DOWN_P && oneclickpls)
			rightArrow.animation.play('press');
		else
			rightArrow.animation.play('idle');

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }

        if (controls.ACCEPT)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));

            weekgroup.forEach(function(spr:FlxSprite)
            {
                if (curSelected != spr.ID)
                {
                    FlxTween.tween(spr, {alpha: 0}, 0.4, {
                        ease: FlxEase.quadOut,
                        onComplete: function(twn:FlxTween)
                        {
                            spr.kill();
                        }
                    });
                }
                else
                {
                    FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
                    {
                        var daChoice:String = weeksnames[curSelected];

                        switch (daChoice)
                        {
                            case 'MoonWeek':
                                /*PlayState.storyPlaylist = ['musica1', 'musica1'];
                                PlayState.isStoryMode = true;
                                PlayState.storyDifficulty = 3;
                        
                                PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + '-hard', StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());      
                                PlayState.campaignScore = 0;
                                Paths.currentModDirectory = "shared";
                                Paths.currentLevel = "shared";

                                PlayState.storyWeek = 1;
                           
                                LoadingState.loadAndSwitchState(new PlayState());
                                trace("SONG LOADED IS " + Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);*/

                                var songArray:Array<String> = [];
                                var leWeek:Array<Dynamic> = loadedWeeks[1].songs;
                                for (i in 0...leWeek.length) {
                                    songArray.push(leWeek[i][0]);
                                }
                             
                                PlayState.storyPlaylist = songArray;
                                PlayState.isStoryMode = true;
                             
                                var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
                                                                    
                                if (diffic == null) {
                                    diffic = '';
                                }
                             
                                PlayState.storyDifficulty = curDifficulty;
                             
                                PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
                                PlayState.campaignScore = 0;
                                PlayState.campaignMisses = 0;
                                {
                                    LoadingState.loadAndSwitchState(new PlayState(), true);
                                    FreeplayState.destroyFreeplayVocals();
                                };

                            case 'JvWeek':
                                /*PlayState.storyPlaylist = ['musica1', 'musica1'];
                                PlayState.isStoryMode = true;
                                PlayState.storyDifficulty = 3;
                        
                                PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + '-hard', StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());      
                                PlayState.campaignScore = 0;
                                Paths.currentModDirectory = "shared";
                                Paths.currentLevel = "shared";

                                PlayState.storyWeek = 1;
                           
                                LoadingState.loadAndSwitchState(new PlayState());
                                trace("SONG LOADED IS " + Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);*/

                                var songArray:Array<String> = [];
                                var leWeek:Array<Dynamic> = loadedWeeks[1].songs;
                                for (i in 0...leWeek.length) {
                                    songArray.push(leWeek[i][0]);
                                }
                             
                                PlayState.storyPlaylist = songArray;
                                PlayState.isStoryMode = true;
                             
                                var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
                                                                    
                                if (diffic == null) {
                                    diffic = '';
                                }
                             
                                PlayState.storyDifficulty = curDifficulty;
                             
                                PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
                                PlayState.campaignScore = 0;
                                PlayState.campaignMisses = 0;
                                {
                                    LoadingState.loadAndSwitchState(new PlayState(), true);
                                    FreeplayState.destroyFreeplayVocals();
                                };
                        }
                    });
                }
            });
        }

        super.update(elapsed);
    }

    function changeItem(huh:Int = 0)
    {
        curSelected += huh;

        FlxG.sound.play(Paths.sound('som do scroll'));

        // - char
        if (curSelected >= chargroup.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = chargroup.length - 1;

        chargroup.forEach(function(spr:FlxSprite)
        {
            spr.alpha = 0;
            FlxTween.tween(spr, {x:481.10, y:-10}, 0.10, {ease: FlxEase.cubeInOut});

            if (spr.ID == curSelected)
            {
                spr.alpha = 1;
                FlxTween.tween(spr, {x:481.10, y:0}, 0.20, {ease: FlxEase.cubeInOut});
                var add:Float = 0;
            }
        });

        // - weeks
        if (curSelected >= weekgroup.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = weekgroup.length - 1;

        weekgroup.forEach(function(spr:FlxSprite)
        {
            spr.alpha = 0;

            if (spr.ID == curSelected)
            {
                spr.alpha = 1;
                var add:Float = 0;
            }
        });
    }
}