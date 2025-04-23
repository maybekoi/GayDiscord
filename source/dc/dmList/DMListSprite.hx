package dc.dmList;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;

class DMListSprite extends FlxSpriteGroup
{
    public var profilePic:FlxSprite;
    public var username:FlxText;
    public var onlineStatus:FlxSprite;
    public var background:FlxSprite;
    public var isSelected:Bool = false;
    
    public function new(X:Float = 0, Y:Float = 0, ?Username:String = "", ?ImagePath:String = "assets/images/default_avatar.png")
    {
        super(X, Y);

        background = new FlxSprite(0, 0);
        background.makeGraphic(200, 42, FlxColor.TRANSPARENT);
        
        profilePic = new FlxSprite(6, 5);
        if (ImagePath != null)
            profilePic.loadGraphic(ImagePath);
        profilePic.setGraphicSize(32, 32);
        profilePic.updateHitbox();
        
        username = new FlxText(profilePic.x + profilePic.width + 12, profilePic.y + 8, 0, Username, 14);
        username.color = FlxColor.WHITE;
        
        onlineStatus = new FlxSprite(profilePic.x + profilePic.width - 10, profilePic.y + profilePic.height - 10);
        onlineStatus.makeGraphic(10, 10, FlxColor.TRANSPARENT);
        
        var matrix:Matrix = new Matrix();
        matrix.translate(1, 1);
        FlxSpriteUtil.drawCircle(onlineStatus, 5, 5, 4, FlxColor.fromRGB(35, 165, 90), 
            {thickness: 2, color: FlxColor.fromRGB(24, 25, 28)});
        
        add(background);
        add(profilePic);
        add(username);
        add(onlineStatus);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        var mouseX:Float = FlxG.mouse.x;
        var mouseY:Float = FlxG.mouse.y;
        
        if (mouseX >= x && mouseX <= x + background.width &&
            mouseY >= y && mouseY <= y + background.height)
        {
            if (!isSelected) {
                background.makeGraphic(200, 42, 0xFF393C43);
            }
            
            if (FlxG.mouse.justPressed) {
                onClick();
            }
        }
        else if (!isSelected) {
            background.makeGraphic(200, 42, FlxColor.TRANSPARENT);
        }
    }
    
    public function onClick():Void {}
    
    public function setSelected(selected:Bool):Void
    {
        isSelected = selected;
        if (isSelected) {
            background.makeGraphic(200, 42, 0xFF454950);
        } else {
            background.makeGraphic(200, 42, FlxColor.TRANSPARENT);
        }
    }
}