package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import lime.app.Application;
import openfl.filters.ShaderFilter;

#if VIDEOS_ALLOWED
import vlc.MP4Handler;
import vlc.MP4Sprite;
#end

class ExemploChomakeyCode extends MusicBeatState
{
    var imagemlol:FlxSprite;
    
    override function create()
    {
        imagemlol = new FlxSprite(0, 0).loadGraphic(Paths.image('sua imagem se voce quiser'));
        imagemlol.screenCenter(XY);
        add(imagemlol);

        chromaVideo('quebrador'); // - seu video

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    function chromaVideo(name:String) // - momento chroma key!!!!1111
    {
        var video = new MP4Sprite(0,0);
        video.scrollFactor.set();
        video.shader = new GreenScreenShader();
        video.visible=false;
        video.finishCallback = function(){
            trace("video gone");
            remove(video);
            video.destroy();
        }
        video.playVideo(Paths.video(name));
        video.readyCallback = function(){
            video.visible=true;
        }
        add(video);
    }
}