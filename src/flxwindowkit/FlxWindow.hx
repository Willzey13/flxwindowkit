// flxwindowkit/Window.hx

package flxwindowkit;

import flxwindowkit.cpp.WindowProperty.Border;

class FlxWindow
{
    public var width:Int;
    public var height:Int;
    public var title:String;
    public var border:Border;

    public function new(?width:Int = 800, ?height:Int = 600, ?title:String = 'Your Game') 
    {
		// super();
        border = new Border();
        this.width = width;
        this.height = height;
        this.title = title;
    }

    public function setColorBorder(color:String = '')
    {
        if (['', ' '].contains(color))
            border.setBorderColor('white');
        else
            border.setBorderColor(color);
    }

    public function showInfo():Void 
    {
        Utils.coloredTrace("Window Info:",          'yellow');
        Utils.coloredTrace("Title: " + this.title,  'green');
        Utils.coloredTrace("Width: " + this.width,  'green');
        Utils.coloredTrace("Height: " + this.height,'green');
    }
}
