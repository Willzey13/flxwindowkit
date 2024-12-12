// flxwindowkit/Window.hx

package flxwindowkit;

import flxwindowkit.cpp.WindowProperty.Border;

class FlxWindow
{
    public var width:Int;
    public var height:Int;
    public var title:String;
    public var border:Border;

    // Construtor da janela
    public function new(width:Int, height:Int, title:String) 
    {
		// super();
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

    // Método para exibir informações da janela
    public function showInfo():Void 
    {
        trace("Window Info:");
        trace("Title: " + this.title);
        trace("Width: " + this.width);
        trace("Height: " + this.height);
    }
}
