package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import flixel.FlxBasic;

class ChomEffect extends FlxBasic 
{
    public var shader:ChromaticAberrationNotPichedShader = new ChromaticAberrationNotPichedShader();
    /*public var rOffset(default, set):Float = 0;
    public var gOffset(default, set):Float = 0;
    public var bOffset(default, set):Float = 0;*/

    public function new(offset:Float = 0.00):Void
    {
      super();
      shader.rOffset.value = [offset];
      shader.gOffset.value = [0.0];
      shader.bOffset.value = [-offset];
    }

    private function setChrome(chromeOffset:Float):Void {
		shader.rOffset.value = [chromeOffset];
		shader.gOffset.value = [0.0];
		shader.bOffset.value = [chromeOffset * -1];
    }

    /*override public function update(elapsed:Float) {
      shader.iTime.value[0] += elapsed;
    }*/
}

class ChromaticAberrationNotPichedShader extends FlxShader {

    @:glFragmentSource('
    #pragma header

    uniform float rOffset;
    uniform float gOffset;
    uniform float bOffset;

    void main()
    {
        vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(rOffset, 0.0));
        vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(gOffset, 0.0));
        vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(bOffset, 0.0));
        vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
        toUse.r = col1.r;
        toUse.g = col2.g;
        toUse.b = col3.b;

        gl_FragColor = toUse;
    }    
    ')
    public function new()
    {
        super();
        /*rOffset.value = [0];
        gOffset.value = [0];
        bOffset.value = [0];*/
    }
}