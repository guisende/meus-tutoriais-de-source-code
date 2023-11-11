package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import flixel.FlxBasic;

class GlitchShaderEffect extends FlxBasic 
{
    public var shader:GlitchShaderShader = new GlitchShaderShader();

    var iTime:Float = 0;

    public var glitchAmplitude(default, set):Float = 0;
    public var glitchNarrowness(default, set):Float = 0;
    public var glitchBlockiness(default, set):Float = 0;
    public var glitchMinimizer(default, set):Float = 0;

    public function new(_glitchAmplitude:Float, _glitchNarrowness:Float, _glitchBlockiness:Float, _glitchMinimizer:Float):Void
    {
        super();
        glitchAmplitude = _glitchAmplitude;
        glitchNarrowness = _glitchNarrowness;
        glitchBlockiness = _glitchBlockiness;
        glitchMinimizer = _glitchMinimizer;
        shader.iTime.value = [0];
		shader.iTime.value = [FlxG.random.float(0,8)];
    }

    override public function update(elapsed:Float):Void{
        super.update(elapsed); // - work shadar
        shader.iTime.value[0] += elapsed;
    }

    function set_glitchAmplitude(v:Float):Float{
		glitchAmplitude = v;
		shader.glitchAmplitude.value = [glitchAmplitude];
		return v;
	}

    function set_glitchNarrowness(v:Float):Float{
		glitchNarrowness = v;
		shader.glitchNarrowness.value = [glitchNarrowness];
		return v;
	}

    function set_glitchBlockiness(v:Float):Float{
		glitchBlockiness = v;
		shader.glitchBlockiness.value = [glitchBlockiness];
		return v;
	}

    function set_glitchMinimizer(v:Float):Float{
		glitchMinimizer = v;
		shader.glitchMinimizer.value = [glitchMinimizer];
		return v;
	}
}

class GlitchShaderShader extends FlxShader {

    @:glFragmentSource('
	#pragma header
	vec2 uv = openfl_TextureCoordv.xy;
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
	vec2 iResolution = openfl_TextureSize;
	uniform float iTime;
	#define iChannel0 bitmap
	#define texture flixel_texture2D
	#define fragColor gl_FragColor
	#define mainImage main
	
	// https://www.shadertoy.com/view/MltBzf
	
	float rand(vec2 p)
	{
		float t = floor(iTime * 20.) / 10.;
		return fract(sin(dot(p, vec2(t * 12.9898, t * 78.233))) * 43758.5453);
	}
	
	float noise(vec2 uv, float blockiness)
	{   
		vec2 lv = fract(uv);
		vec2 id = floor(uv);
		
		float n1 = rand(id);
		float n2 = rand(id+vec2(1,0));
		float n3 = rand(id+vec2(0,1));
		float n4 = rand(id+vec2(1,1));
		
		vec2 u = smoothstep(0.0, 1.0 + blockiness, lv);
	
		return mix(mix(n1, n2, u.x), mix(n3, n4, u.x), u.y);
	}
	
	float fbm(vec2 uv, int count, float blockiness, float complexity)
	{
		float val = 0.0;
		float amp = 0.5;
		
		while(count != 0)
		{
			val += amp * noise(uv, blockiness);
			amp *= 0.5;
			uv *= complexity;    
			count--;
		}
		
		return val;
	}
	
	uniform float glitchAmplitude;
	uniform float glitchNarrowness;
	uniform float glitchBlockiness;
	uniform float glitchMinimizer;
	
	void main()
	{
		// Normalized pixel coordinates (from 0 to 1)
		vec2 uv = fragCoord/iResolution.xy;
		vec2 a = vec2(uv.x * (iResolution.x / iResolution.y), uv.y);
		vec2 uv2 = vec2(a.x / iResolution.x, exp(a.y));
		vec2 id = floor(uv * 8.0);
		//id.x /= floor(texture(iChannel0, vec2(id / 8.0)).r * 8.0);
	
		// Generate shift amplitude
		float shift = glitchAmplitude * pow(fbm(uv2, int(rand(id) * 6.), glitchBlockiness, glitchNarrowness), glitchMinimizer);
		
		// Create a scanline effect
		float scanline = abs(cos(uv.y * 400.));
		scanline = smoothstep(0.0, 2.0, scanline);
		shift = smoothstep(0.00001, 0.2, shift);
		
		// Apply glitch and RGB shift
		float colR = texture(iChannel0, vec2(uv.x + shift, uv.y)).r * (1. - shift) ;
		float colG = texture(iChannel0, vec2(uv.x - shift, uv.y)).g * (1. - shift) + rand(id) * shift;
		float colB = texture(iChannel0, vec2(uv.x - shift, uv.y)).b * (1. - shift);
		// Mix with the scanline effect
		vec3 f = vec3(colR, colG, colB) - (0.1 * scanline);
		
		// Output to screen
		fragColor = vec4(f, 1.0);
        gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
	}   
    ')
    public function new()
    {
        super();
    }
}